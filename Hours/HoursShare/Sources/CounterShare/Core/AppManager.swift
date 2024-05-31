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

    // MARK: Onboarding

    public private(set) var onboardingIndices = [OnboardingIndices]()

    // MARK: Calendar

    private let eventStore = EKEventStore()
    public private(set) var calendarAccessGranted: Bool = false
    private var deleteEventIdentifiers = Map<String, Int>()

    // MARK: HealthKit

    private lazy var healthStore = HKHealthStore()
    public private(set) var healthAccessGranted = false

    // MARK: BackgroundTask

    private var observer: NSObjectProtocol?
    private let identifier = "cn.com.nostudio.napnap.backgroundFetch.identifier"
    private let operationQueue: OperationQueue = .init()

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

        if isAutoSyncSleep || isAutoSyncWorkout {
            requestHealthAccess()
        }
    }

    // MARK: Timer

    public func startTimer() {
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
            if index == .health, !HKHealthStore.isHealthDataAvailable() { continue }
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
    var isHealthAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

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

            if granted {
                self?.enableObservedSleepAnalysis()
                self?.enableObservedWorkout()

                self?.autoSyncWorkout()
                self?.autoSyncSleep()
            }

            DispatchQueue.main.async {
                completion?(granted)
            }
        }
    }

    func autoSyncHealth(completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else {
            completionHandler?()
            return
        }

        let group = DispatchGroup()
        group.enter()
        autoSyncSleep {
            group.leave()
        }
        group.enter()
        autoSyncWorkout {
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            completionHandler?()
        }
    }

    // MARK: Workout

    func enableObservedWorkout() {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let workoutType = HKObjectType.workoutType()
        let query = HKObserverQuery(sampleType: workoutType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error = error { print(error) }
            self?.autoSyncWorkout(completionHandler: completionHandler)
        }
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: workoutType, frequency: .immediate) { _, error in
            if let error = error {
                print(error)
            }
        }
    }

    func autoSyncWorkout(completionHandler: (() -> Void)? = nil) {
        guard isAutoSyncSleep else {
            completionHandler?()
            return
        }

        let from = Storage.default.lastSyncWorkoutDate?.addingTimeInterval(-3 * 24 * 3600) ?? initialDate
        let to = Date()

        if from.distance(to: to) < 30 {
            completionHandler?()
            return
        }
        Storage.default.lastSyncWorkoutDate = to

        syncWorkout(from: from, to: to, completionHandler: completionHandler)
    }

    private func syncWorkout(from: Date, to: Date, completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            guard error == nil, let workouts = samples as? [HKWorkout], !workouts.isEmpty else {
                completionHandler?()
                return
            }

            DispatchQueue.main.async {
                self?.saveWorkouts(workouts, completionHandler: completionHandler)
            }
        }
        healthStore.execute(query)
    }

    private var healthCategory: CategoryObject {
        let realm = DBManager.default.realm

        if let health = realm.objects(CategoryObject.self).first(where: { $0.name == R.string.localizable.health() }) {
            return health
        } else {
            let category = CategoryObject(hex: DBManager.default.nextHex, emoji: "❤️", name: R.string.localizable.health())
            realm.writeAsync {
                realm.add(category)
            }
            return category
        }
    }

    private func saveWorkouts(_ workouts: [HKWorkout], completionHandler: (() -> Void)? = nil) {
        let realm = DBManager.default.realm
        let category: CategoryObject = healthCategory

        for workout in workouts {
            let id = workout.uuid.uuidString
            guard !realm.objects(RecordObject.self).contains(where: { $0.healthSampleUUIDString == id }) else { continue }

            let name = workout.workoutActivityType.name
            let emoji = workout.workoutActivityType.emoji

            let newRecord = RecordObject(creationMode: .health, startAt: workout.startDate, endAt: workout.endDate)
            newRecord.healthSampleUUIDString = id
            if let eventObject = realm.objects(EventObject.self).first(where: { $0.name == name && $0.emoji == emoji }) {
                realm.writeAsync {
                    // 同步到日历
                    newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: eventObject, record: newRecord)
                    eventObject.items.append(newRecord)
                }
            } else {
                try? realm.write {
                    let event = EventObject(emoji: emoji, name: name, hex: DBManager.default.nextHex, isSystem: true)
                    event.items.append(newRecord)

                    // 同步到日历
                    newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    realm.add(event)

                    category.events.append(event)
                }
            }
        }

        // 稍微延迟一下，等数据入库完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completionHandler?()
        }
    }

    // MARK: Sleep

    func enableObservedSleepAnalysis() {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let sleepType = HKCategoryType(.sleepAnalysis)
        let query = HKObserverQuery(sampleType: sleepType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error = error { print(error) }
            self?.autoSyncSleep(completionHandler: completionHandler)
        }
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sleepType, frequency: .immediate) { _, error in
            if let error = error {
                print(error)
            }
        }
    }

    func autoSyncSleep(completionHandler: (() -> Void)? = nil) {
        guard isAutoSyncSleep else {
            completionHandler?()
            return
        }

        let from = Storage.default.lastSyncSleepDate?.addingTimeInterval(-3 * 24 * 3600) ?? initialDate
        let to = Date()

        if from.distance(to: to) < 30 {
            completionHandler?()
            return
        }
        Storage.default.lastSyncSleepDate = to

        syncSleep(from: from, to: to, completionHandler: completionHandler)
    }

    private func syncSleep(from: Date, to: Date, completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else { return }

        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            guard error == nil, let items = samples as? [HKCategorySample], !items.isEmpty else {
                completionHandler?()
                return
            }

            DispatchQueue.main.async {
                self?.saveSleep(items, completionHandler: completionHandler)
            }
        }
        healthStore.execute(query)
    }

    private func saveSleep(_ samples: [HKCategorySample], completionHandler: (() -> Void)? = nil) {
        let realm = DBManager.default.realm
        let category: CategoryObject = healthCategory

        let name = R.string.localizable.sleep()
        let emoji = "🛌"
        var event: EventObject
        if let eventObject = realm.objects(EventObject.self).first(where: { $0.name == name && $0.emoji == emoji }) {
            event = eventObject
        } else {
            event = EventObject(emoji: emoji, name: name, hex: DBManager.default.nextHex, isSystem: true)
            try? realm.write {
                category.events.append(event)
            }
        }

        var records = [RecordObject]()

        for item in samples {
            guard let type = HKCategoryValueSleepAnalysis(rawValue: item.value), type == .inBed else { continue }

            guard !realm.objects(RecordObject.self).contains(where: { $0.startAt <= item.startDate && $0.endAt >= item.endDate }) else { continue }

            // 当睡眠数据非连续时，进行合并，让数据完整
            if let last = records.last, last.endAt.distance(to: item.startDate) < 90 * 60 {
                last.endAt = item.endDate
            } else {
                let record = RecordObject(creationMode: .health, startAt: item.startDate, endAt: item.endDate)
                record.healthSampleUUIDString = item.uuid.uuidString
                records.append(record)
            }
        }

        realm.writeAsync {
            // 过滤掉时间非连续，并且时长小于 5 分的数据
            let filtedRecord = records.filter { $0.milliseconds > 300 * 1000 }
            event.items.append(objectsIn: filtedRecord)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completionHandler?()
        }
    }
}

// MARK: - BackgroudTask

public extension AppManager {
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            self.handleAppRefresh(task: task as? BGAppRefreshTask)
        }
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        // Fetch no earlier than 5 minutes from now.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            debugPrint("Could not schedule app refresh: \(error)")
        }
    }

    func checkBackgroundRefreshStatus() -> UIBackgroundRefreshStatus {
        UIApplication.shared.backgroundRefreshStatus
    }

    func handleAppRefresh(task: BGAppRefreshTask?) {
        guard let task else { return }
        // Schedule a new refresh task.
        scheduleAppRefresh()

        autoSyncHealth {
            task.setTaskCompleted(success: true)
        }
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
    }
}
