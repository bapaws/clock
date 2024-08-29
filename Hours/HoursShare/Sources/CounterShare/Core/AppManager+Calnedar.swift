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
    var calendarAuthorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    func requestCalendarAccess(completion: ((Bool) -> Void)? = nil) {
        let completionHandler: EKEventStoreRequestAccessCompletionHandler = { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.calendarAccessGranted = granted
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

    func importEventsFromCalendar(by entity: CategoryEntity) async {
        guard let calendarIdentifier = entity.calendarIdentifier else { return }
        guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }

        if let category = await AppRealm.shared.getCategory(by: calendar) {
            for event in entity.events {
                if var eventEntity = category.events.first(where: { $0.title == event.title || $0.name == event.title }) {
                    // 存在数据，但是已被删除
                    if eventEntity.deletedAt != nil {
                        eventEntity.deletedAt = nil
                        await AppRealm.shared.writeEvent(eventEntity, addTo: category)
                    }
                } else {
                    await AppRealm.shared.writeEvent(event, addTo: category)
                }
            }
        } else {
            await AppRealm.shared.writeCategory(entity)
        }
    }

    func importRecordsFromCalendar(by entity: CategoryEntity, startAt: Date? = nil, endAt: Date = Date()) async {
        let startAt = startAt ?? endAt.dateAt(.prevYear).date

        guard let calendarIdentifier = entity.calendarIdentifier else { return }
        guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }

        /// 先导入所有的分类和事件
        await importEventsFromCalendar(by: entity)
        /// 上一部中导入了所有的分类和事件，这里正常能获取到分类
        guard let category = await AppRealm.shared.getCategory(by: calendar) else { return }

        let predicate = eventStore.predicateForEvents(withStart: startAt, end: endAt, calendars: [calendar])
        let calendarEvents = eventStore.events(matching: predicate)

        // 如果已导入，或者名称相同，则直接导入事件和记录
        var eventEntities: IdentifiedArrayOf<EventEntity> = []
        for calendarEvent in calendarEvents {
            /// 记录查询：
            /// 1. 如果存在 id 相同的，说明存在。（需要判断是否被删除）
            /// 2. 如果记录的事件与日历事件标题相同 & 开始时间和结束时间相同，也说明存在。
            let titles = calendarEvent.title.split(separator: " ").map { String($0) }
            var calendarEventEmoji: String?
            var calendarEventName: String
            if titles.count == 2, titles[0].isEmoji {
                calendarEventEmoji = titles[0]
                calendarEventName = titles[1]
            } else {
                calendarEventName = calendarEvent.title
            }

            let recordWhere: (Query<RecordObject>) -> Query<Bool> = {
                let isEventIDEqual = $0.calendarEventIdentifier == calendarEvent.eventIdentifier
                let isEventTitleEqual = $0.events.emoji == calendarEventEmoji && $0.events.name == calendarEventName
                let isDateEqual = $0.startAt == calendarEvent.startDate && $0.endAt == calendarEvent.endDate
                return isEventIDEqual || (isEventTitleEqual && isDateEqual)
            }
            // 如果已经存在记录，说明数据已导入
            if var record = await AppRealm.shared.findRecords(where: recordWhere).first {
                record.calendarEventIdentifier = calendarEvent.eventIdentifier
                record.deletedAt = nil
                // 这里为了方便，直接更新记录
                await AppRealm.shared.updateRecord(record)
                continue
            }

            // 获取事件
            guard let title = calendarEvent.title, let importEventEntity = entity.events.first(where: { $0.name == title || $0.title == title }) else { continue }

            var recordEntity = RecordEntity(creationMode: .calendar, startAt: calendarEvent.startDate, endAt: calendarEvent.endDate)
            recordEntity.notes = calendarEvent.notes
            recordEntity.calendarEventIdentifier = calendarEvent.eventIdentifier

            /// 先从数据库里查询相同标题的事件
            /// - 存在：表示已导入过，所以数据库已有的事件
            /// - 不存在：未导入过，所以使用新建的事件
            let eventEntity: EventEntity = await AppRealm.shared.getEvent(by: calendarEvent) ?? importEventEntity
            if eventEntities[id: eventEntity.id] == nil {
                eventEntities.append(eventEntity)
            }
            eventEntities[id: eventEntity.id]?.items.append(recordEntity)

            /// 分页写入数据：
            /// 如果一条一条写入记录量大，导致大量的 CloudKit 请求发送
            /// 如果一次性写入所有记录，导致单次请求数据超过限制
            if let eventEntity = eventEntities[id: eventEntity.id], eventEntity.items.count > 15 {
                await AppRealm.shared.writeRecords(eventEntity.items, addTo: eventEntity)
                eventEntities.remove(id: eventEntity.id)
            }
        }
        /// 写入剩余不足一页的记录
        for entity in eventEntities {
            if let eventEntity: EventEntity = await AppRealm.shared.getEvent(by: entity.id) {
                await AppRealm.shared.writeRecords(entity.items, addTo: eventEntity)
            } else {
                await AppRealm.shared.writeEvent(entity, addTo: category)
            }
        }
    }
}

// MARK: Update

public extension AppManager {
    @discardableResult
    private func findOrCreateCalendar(for category: CategoryEntity?, calendars: [EKCalendar]? = nil) async -> EKCalendar? {
        guard var category = category else { return nil }

        let calendars = calendars ?? eventStore.calendars(for: .event)
        if let calendar = calendars.first(where: { $0.title == category.title || $0.title == category.name }) {
            if calendar.calendarIdentifier != category.calendarIdentifier {
                // 更新分类
                category.calendarIdentifier = calendar.calendarIdentifier
                await AppRealm.shared.writeCategory(category)
            }
            return calendar
        } else {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.title = category.title
            calendar.cgColor = category.color.cgColor
            calendar.source = eventStore.sources.first(where: { $0.sourceType == .calDAV && $0.title == "iCloud" }) ?? eventStore.defaultCalendarForNewEvents?.source
            try? eventStore.saveCalendar(calendar, commit: false)

            // 更新分类
            category.calendarIdentifier = calendar.calendarIdentifier
            await AppRealm.shared.writeCategory(category)

            return calendar
        }
    }

    func syncToCalendar(for eventObject: EventEntity, record: RecordEntity) async -> String? {
        guard calendarAccessGranted else { return nil }

        do {
            // 如果是修改记录，先删除记录
            if let eventIdentifier = record.calendarEventIdentifier {
                deleteCalendarEvent(for: eventIdentifier)
            }

            let calendar: EKCalendar? = await findOrCreateCalendar(for: eventObject.category)

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

    func updateCalendarEvents(by eventObject: EventEntity) async {
        do {
            let calendar: EKCalendar? = await findOrCreateCalendar(for: eventObject.category)

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
