//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/17.
//

import EventKit
import Foundation
import IdentifiedCollections
import Palette
import RealmSwift
import SwiftDate
import UIKit

// MARK: Access

public extension AppManager {
    func requestCalendarAccess(completion: ((Bool) -> Void)? = nil) {
        let completionHandler: EKEventStoreRequestAccessCompletionHandler = { [weak self] granted, _ in
            self?.calendarAccessGranted = granted

            DispatchQueue.main.async {
                completion?(granted)
            }
        }
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: completionHandler)
        } else {
            eventStore.requestAccess(to: .event, completion: completionHandler)
        }
    }
}

// MARK: Load

public extension AppManager {
    func loadCalendars(startAt: Date? = nil, endAt: Date = Date()) -> [CategoryEntity] {
        let startAt = startAt ?? endAt.dateAt(.prevYear).date
        let calendars = eventStore.calendars(for: .event)
        var categories: [CategoryEntity] = []
        for calendar in calendars where calendar.type == .calDAV || calendar.type == .local || calendar.type == .exchange {
            let uiColor = UIColor(cgColor: calendar.cgColor)
            let hex = HexEntity(rgb: uiColor.argb)
            let title = calendar.title
            var category = CategoryEntity(hex: hex, title: title)
            category.calendarIdentifier = calendar.calendarIdentifier

            let predicate = eventStore.predicateForEvents(withStart: startAt, end: endAt, calendars: [calendar])
            let events = eventStore.events(matching: predicate)
            guard !events.isEmpty else { continue }

            for event in events {
                guard let title = event.title else { continue }
                if !category.events.contains(where: { $0.title == title || $0.name == title }) {
                    var eventEntity = EventEntity(hex: HexEntity.random(), title: title)
                    eventEntity.category = category
                    category.events.append(eventEntity)
                }
            }
            categories.append(category)
        }
        return categories
    }

    func importEventsFromCalendar(by entity: CategoryEntity, startAt: Date? = nil, endAt: Date = Date()) async {
        let startAt = startAt ?? endAt.dateAt(.prevYear).date

        guard let calendarIdentifier = entity.calendarIdentifier else { return }
        guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }

        let predicate = eventStore.predicateForEvents(withStart: startAt, end: endAt, calendars: [calendar])
        let events = eventStore.events(matching: predicate)

        let category = await AppRealm.shared.getCategory(by: calendar) ?? entity
        for event in events {
            // 获取事件
            guard let title = event.title, let importEvent = entity.events.first(where: { $0.name == title || $0.title == title }) else { continue }
            // 已存在事件，导入记录
            if await AppRealm.shared.getEvent(by: event) == nil {
                await AppRealm.shared.writeEvent(importEvent, addTo: category)
            }
        }
        await AppRealm.shared.writeCategory(category)
    }

    func importRecordsFromCalendar(by entity: CategoryEntity, startAt: Date? = nil, endAt: Date = Date()) async {
        let startAt = startAt ?? endAt.dateAt(.prevYear).date

        guard let calendarIdentifier = entity.calendarIdentifier else { return }
        guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }

        let predicate = eventStore.predicateForEvents(withStart: startAt, end: endAt, calendars: [calendar])
        let events = eventStore.events(matching: predicate)

        // 如果已导入，或者名称相同，则直接导入事件和记录
        if let category = await AppRealm.shared.getCategory(by: calendar) {
            for event in events {
                // 如果已经存在记录，说明数据已导入
                if !(await AppRealm.shared.getRecords(where: { $0.calendarEventIdentifier == event.eventIdentifier }).isEmpty) {
                    continue
                }

                // 获取事件
                guard let title = event.title, let importEvent = entity.events.first(where: { $0.name == title || $0.title == title }) else { continue }

                var recordEntity = RecordEntity(creationMode: .calendar, startAt: event.startDate, endAt: event.endDate)
                recordEntity.notes = event.notes
                // 已存在事件，导入记录
                if let event = await AppRealm.shared.getEvent(by: event) {
                    await AppRealm.shared.writeRecord(recordEntity, addTo: event)
                } else {
                    await AppRealm.shared.writeEvent(importEvent, addTo: category)
                    await AppRealm.shared.writeRecord(recordEntity, addTo: importEvent)
                }
            }

            return
        }

        var category = entity
        for event in events {
            // 如果已经存在记录，说明数据已导入
            if !(await AppRealm.shared.getRecords(where: { $0.calendarEventIdentifier == event.eventIdentifier }).isEmpty) {
                continue
            }

            // 获取事件
            guard let title = event.title, let eventIndex = entity.events.firstIndex(where: { $0.name == title || $0.title == title }) else { continue }

            var recordEntity = RecordEntity(creationMode: .calendar, startAt: event.startDate, endAt: event.endDate)
            recordEntity.notes = event.notes
            category.events[eventIndex].items.append(recordEntity)
        }
        await AppRealm.shared.writeCategory(category)
    }
}

// MARK: Update

public extension AppManager {
    private func writeCalendarIdentifier(_ id: String, for entity: CategoryEntity) {
        Task {
            await AppRealm.shared.writeCalendarIdentifier(id, for: entity)
        }
    }

    @discardableResult
    private func findOrCreateCalendar(for category: CategoryEntity?, calendars: [EKCalendar]? = nil) -> EKCalendar? {
        guard let category = category else { return nil }

        let title = "\(category.emoji ?? "") \(category.name)"
        let calendars = calendars ?? eventStore.calendars(for: .event)
        if let calendar = calendars.first(where: { $0.title == title }) {
            if calendar.calendarIdentifier != category.calendarIdentifier {
                writeCalendarIdentifier(calendar.calendarIdentifier, for: category)
            }
            return calendar
        } else {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.title = title
            calendar.cgColor = category.color.cgColor
            calendar.source = eventStore.sources.first(where: { $0.sourceType == .calDAV && $0.title == "iCloud" }) ?? eventStore.defaultCalendarForNewEvents?.source
            try? eventStore.saveCalendar(calendar, commit: false)

            writeCalendarIdentifier(calendar.calendarIdentifier, for: category)
            return calendar
        }
    }

    func syncToCalendar(for eventObject: EventEntity, record: RecordEntity) -> String? {
        guard calendarAccessGranted else { return nil }

        do {
            // 如果是修改记录，现删除记录
            if let eventIdentifier = record.calendarEventIdentifier {
                deleteCalendarEvent(for: eventIdentifier)
            }

            let calendar: EKCalendar? = findOrCreateCalendar(for: eventObject.category)

            let event = EKEvent(eventStore: eventStore)
            event.title = eventObject.title
            event.location = record.milliseconds.timeLengthText
            event.startDate = record.startAt
            event.endDate = record.endAt
            event.notes = record.notes
            event.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
            try eventStore.save(event, span: .thisEvent, commit: false)

            try eventStore.commit()

            return event.eventIdentifier
        } catch {
            print(error)
            return nil
        }
    }

    func deleteCalendarEvent(for identifier: String) {
        if let event = eventStore.event(withIdentifier: identifier) {
            try? eventStore.remove(event, span: .thisEvent)
        } else {
            let count = deleteEventIdentifiers[identifier] ?? 3
            if count == 0 {
                deleteEventIdentifiers.removeObject(for: identifier)
                return
            }
            deleteEventIdentifiers[identifier] = count - 1
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.deleteCalendarEvent(for: identifier)
            }
        }
    }

    func updateCalendarEvents(by eventObject: EventEntity) {
        do {
            let calendar: EKCalendar? = findOrCreateCalendar(for: eventObject.category)

            for record in eventObject.items {
                guard let calendarEventIdentifier = record.calendarEventIdentifier else { continue }

                if let event = eventStore.event(withIdentifier: calendarEventIdentifier) {
                    event.title = eventObject.title
                    event.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
                    try eventStore.save(event, span: .thisEvent, commit: false)
                }
            }

            try eventStore.commit()
        } catch {
            print(error)
        }
    }

    func updateCalendar(by category: CategoryEntity) {
        do {
            guard let calendarIdentifier = category.calendarIdentifier else { return }
            guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }
            calendar.title = category.title
            calendar.cgColor = category.color.cgColor
            try eventStore.saveCalendar(calendar, commit: true)
        } catch {
            print(error)
        }
    }
}
