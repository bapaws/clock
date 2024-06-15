//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import AVFoundation
import BackgroundTasks
import ClockShare
import EventKit
import Foundation
import HealthKit
import RealmSwift
import SwiftUI

open class AppManager: ClockShare.AppBaseManager {
    @Published public var today: Date = Date().dateAtStartOf(.day)

    // MARK: Record

    @AppStorage(Storage.Key.minimumRecordedTime, store: Storage.default.store)
    public var minimumRecordedTime: TimeInterval = 60

    /// 最长记录时间，单位小时
    @AppStorage(Storage.Key.maximumRecordedTime, store: Storage.default.store)
    public var maximumRecordedTime: TimeInterval = 6 * 60 * 60

    @AppStorage(Storage.Key.isSyncRecordsToCalendar, store: Storage.default.store)
    public var isSyncRecordsToCalendar: Bool = false

    @AppStorage(Storage.Key.isAutoSyncSleep, store: Storage.default.store)
    public var isAutoSyncSleep: Bool = false

    @AppStorage(Storage.Key.isAutoSyncWorkout, store: Storage.default.store)
    public var isAutoSyncWorkout: Bool = false

    // MARK: App Screen Time

    @AppStorage(Storage.Key.minimumRecordedScreenTime, store: Storage.default.store)
    public var minimumRecordedScreenTime: TimeInterval = 10

    @AppStorage(Storage.Key.isAutoMergeAdjacentRecords, store: Storage.default.store)
    public var isAutoMergeAdjacentRecords: Bool = false

    @AppStorage(Storage.Key.autoMergeAdjacentRecordsInterval, store: Storage.default.store)
    public var autoMergeAdjacentRecordsInterval: TimeInterval = 30

    // MARK: Calendar

    private let eventStore = EKEventStore()
    public private(set) var calendarAccessGranted: Bool = false
    private var deleteEventIdentifiers = Map<String, Int>()

    /// 可以记录的初始时间
    public let initialDate = Date(year: 2023, month: 1, day: 1, hour: 0, minute: 0)

    override public init() {
        super.init()
        Storage.default.store.removeObject(forKey: Storage.Key.timingMode)

        isPomodoroStopped = false
        isTimerStopped = false

        if isSyncRecordsToCalendar {
            requestCalendarAccess()
        }
    }
}

// MARK: Calendar

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

//    func createCalendars(for result: Results<CategoryObject>) {
//        let calendars = eventStore.calendars(for: .event)
//        for category in result {
//            findOrCreateCalendar(for: category, calendars: calendars)
//        }
//        try? eventStore.commit()
//    }

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
        guard calendarAccessGranted, isSyncRecordsToCalendar else { return nil }

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
}
