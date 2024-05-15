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
import HealthKit
import RealmSwift
import SwiftUI

// MARK: Onboarding

public enum OnboardingIndices: Int, CaseIterable {
    case welcome, appScreenTime, health, calendar, statistics

    public var storeKey: String { Storage.Key.onboardingVersion + "\(rawValue)" }
    public var version: Int { 1 }
}

public class AppManager: ClockShare.AppBaseManager {
    public static let shared = AppManager()

    private var timer: Timer?
    @Published public var today: Date = Date().dateAtStartOf(.day)

    // MARK: Record

    @AppStorage(Storage.Key.minimumRecordedTime, store: Storage.default.store)
    public var minimumRecordedTime: TimeInterval = 60

    /// 最长记录时间，单位小时
    @AppStorage(Storage.Key.maximumRecordedTime, store: Storage.default.store)
    public var maximumRecordedTime: TimeInterval = 6 * 60 * 60

    @AppStorage(Storage.Key.isSyncRecordsToCalendar, store: Storage.default.store)
    public var isSyncRecordsToCalendar: Bool = false

    @AppStorage(Storage.Key.isAutoSyncHealth, store: Storage.default.store)
    public var isAutoSyncHealth: Bool = false

    // MARK: App Screen Time

    @AppStorage(Storage.Key.minimumRecordedScreenTime, store: Storage.default.store)
    public var minimumRecordedScreenTime: TimeInterval = 10

    @AppStorage(Storage.Key.isAutoMergeAdjacentRecords, store: Storage.default.store)
    public var isAutoMergeAdjacentRecords: Bool = false

    @AppStorage(Storage.Key.autoMergeAdjacentRecordsInterval, store: Storage.default.store)
    public var autoMergeAdjacentRecordsInterval: TimeInterval = 30

    // MARK: Onboarding

    public private(set) var onboardingIndices = [OnboardingIndices]()

    // MARK: Calendar

    private let eventStore = EKEventStore()
    public private(set) var calendarAccessGranted: Bool = false
    private var deleteEventIdentifiers = Map<String, Int>()

    // MARK: HealthKit

    private lazy var healthStore = HKHealthStore()
    public private(set) var healthAccessGranted = false

    /// 可以记录的初始时间
    public let initialDate = Date(year: 2023, month: 1, day: 1, hour: 0, minute: 0)

    override private init() {
        super.init()
        Storage.default.store.removeObject(forKey: Storage.Key.timingMode)

        isPomodoroStopped = false
        isTimerStopped = false

        setupOnboardingIndices()

        if isSyncRecordsToCalendar {
            requestCalendarAccess()
        }

        if isAutoSyncHealth {
            requestHealthAccess()
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

// MARK: Onboarding

public extension AppManager {
    func setupOnboardingIndices() {
        let store = Storage.default.store
        for index in OnboardingIndices.allCases where store.integer(forKey: index.storeKey) != index.version {
            if index == .health && !HKHealthStore.isHealthDataAvailable() { continue }
            onboardingIndices.append(index)
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

    func createCalendars(for result: Results<CategoryObject>) {
        let calendars = eventStore.calendars(for: .event)
        for category in result {
            findOrCreateCalendar(for: category, calendars: calendars)
        }
        try? eventStore.commit()
    }

    @discardableResult
    private func findOrCreateCalendar(for category: CategoryObject?, calendars: [EKCalendar]? = nil) -> EKCalendar? {
        guard let category = category else { return nil }

        let title = "\(category.emoji ?? "") \(category.name)"
        let calendars = calendars ?? eventStore.calendars(for: .event)
        if let calendar = calendars.first(where: { $0.title == title }) {
            if calendar.calendarIdentifier != category.calendarIdentifier, let thawedObject = category.thaw() {
                thawedObject.realm?.writeAsync {
                    thawedObject.calendarIdentifier = calendar.calendarIdentifier
                }
            }
            return calendar
        } else {
            let calendar = EKCalendar(for: .event, eventStore: eventStore)
            calendar.title = title
            calendar.cgColor = category.color.cgColor
            calendar.source = eventStore.sources.first(where: { $0.sourceType == .calDAV && $0.title == "iCloud" }) ?? eventStore.defaultCalendarForNewEvents?.source
            try? eventStore.saveCalendar(calendar, commit: false)

            if let thawedObject = category.thaw() {
                thawedObject.realm?.writeAsync {
                    thawedObject.calendarIdentifier = calendar.calendarIdentifier
                }
            }
            return calendar
        }
    }

    func syncToCalendar(for eventObject: EventObject, record: RecordObject) -> String? {
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

    func updateCalendarEvents(by eventObject: EventObject) {
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

// MARK: HealthKit

public extension AppManager {
    func requestHealthAccess(completion: ((Bool) -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion?(false)
            return
        }

        let allTypes: Set = [
            HKCategoryType(.sleepAnalysis),
            HKQuantityType.workoutType(),
        ]
        healthStore.requestAuthorization(toShare: nil, read: allTypes) { [weak self] granted, _ in
            self?.healthAccessGranted = granted

            if granted, self?.isAutoSyncHealth == true {
                self?.syncSleep()
                self?.syncWorkout()
            }

            DispatchQueue.main.async {
                completion?(granted)
            }
        }
    }

    func syncHealth() {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted, isAutoSyncHealth else { return }

        syncWorkout()
        syncSleep()
    }

    func syncWorkout() {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let from = Storage.default.lastSyncWorkoutDate ?? initialDate
        let to = Date()

        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            guard error == nil, let workouts = samples as? [HKWorkout] else { return }

            DispatchQueue.main.async {
                self?.saveWorkouts(workouts)
            }
        }
        healthStore.execute(query)
    }

    private func saveWorkouts(_ workouts: [HKWorkout]) {
        let realm = DBManager.default.realm
        var category: CategoryObject
        if let health = realm.objects(CategoryObject.self).first(where: { $0.name == R.string.localizable.health() }) {
            category = health
        } else {
            category = CategoryObject(hex: DBManager.default.nextHex, emoji: "❤️", name: R.string.localizable.health())
            realm.writeAsync {
                realm.add(category)
            }
        }

        for workout in workouts {
            let id = workout.uuid.uuidString
            guard !realm.objects(RecordObject.self).contains(where: { $0.healthSampleUUIDString == id }) else { continue }

            let name = workout.workoutActivityType.name
            let emoji = workout.workoutActivityType.emoji

            let newRecord = RecordObject(creationMode: .health, startAt: workout.startDate, endAt: workout.endDate)
            newRecord.healthSampleUUIDString = id
            if let eventObject = realm.objects(EventObject.self).first(where: { $0.name == name && $0.emoji == emoji }) {
                realm.writeAsync {
//                    category.events.append(eventObject)
                    // 同步到日历
                    newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: eventObject, record: newRecord)
                    eventObject.items.append(newRecord)
                }
            } else {
                realm.writeAsync {
                    let event = EventObject(emoji: emoji, name: name, hex: DBManager.default.nextHex, isSystem: true)
                    event.items.append(newRecord)

                    // 同步到日历
                    newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)

                    category.events.append(event)
                }
            }
        }
    }

    func syncSleep() {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let from = Storage.default.lastSyncSleepDate ?? initialDate
        let to = Date()

        if to.timeIntervalSince1970 - from.timeIntervalSince1970 < 10 { return }

        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
            print(samples)
            guard error == nil, let workouts = samples as? [HKCategorySample] else {
                return
            }
            print(workouts)
        }
        healthStore.execute(query)
    }
}
