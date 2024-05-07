//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import AVFoundation
import ClockShare
import EventKit
import Foundation
import RealmSwift
import SwiftUI

public class AppManager: ClockShare.AppBaseManager {
    public static let shared = AppManager()

    private var timer: Timer?
    @Published public var today: Date = Date().dateAtStartOf(.day)

    @AppStorage(Storage.Key.minimumRecordedTime, store: Storage.default.store)
    public var minimumRecordedTime: TimeInterval = 60

    /// 最长记录时间，单位小时
    @AppStorage(Storage.Key.maximumRecordedTime, store: Storage.default.store)
    public var maximumRecordedTime: TimeInterval = 6 * 60 * 60

    @AppStorage(Storage.Key.isSyncRecordsToCalendar, store: Storage.default.store)
    public var isSyncRecordsToCalendar: Bool = false

    // MARK: Calendar

    private let eventStore = EKEventStore()
    public private(set) var calendarAccessGranted: Bool = false
    private var deleteEventIdentifiers = Map<String, Int>()

    /// 可以记录的初始时间
    public let initialDate = Date(year: 2023, month: 1, day: 1, hour: 0, minute: 0)

    override private init() {
        super.init()
        Storage.default.store.removeObject(forKey: Storage.Key.timingMode)

        isPomodoroStopped = false
        isTimerStopped = false

        if isSyncRecordsToCalendar {
            requestAccess()
        }
    }

    // MARK: Timer

    private func startTimer() {
        let now = Date()
#if targetEnvironment(simulator)
        let distance = 120.0
#else
        let distance = now.distance(to: now.dateAt(.tomorrowAtStart))
#endif

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: distance, repeats: false) { [weak self] _ in
            self?.today = Date().dateAt(.startOfDay)
            self?.startTimer()
        }
    }
}

// MARK: Calendar

public extension AppManager {
    func requestAccess(completion: ((Bool) -> Void)? = nil) {
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

    func syncToCalendar(for eventObject: EventObject, record: RecordObject) -> String? {
        guard calendarAccessGranted, isSyncRecordsToCalendar else { return nil }

        do {
            // 如果是修改记录，现删除记录
            if let eventIdentifier = record.calendarEventIdentifier {
                deleteEvent(for: eventIdentifier)
            }

            let event = EKEvent(eventStore: eventStore)
            event.title = "\(eventObject.emoji ?? "") \(eventObject.name)"
            event.startDate = record.startAt
            event.endDate = record.endAt
            event.calendar = eventStore.defaultCalendarForNewEvents

            try eventStore.save(event, span: .thisEvent, commit: true)
            return event.eventIdentifier
        } catch {
            print(error)
            return nil
        }
    }

    func deleteEvent(for identifier: String) {
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
                self?.deleteEvent(for: identifier)
            }
        }
    }
}
