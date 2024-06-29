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
import HoursShare
import RealmSwift
import SwiftUI

// MARK: Onboarding

public enum OnboardingIndices: Int, CaseIterable {
    case welcome, appScreenTime, health, calendar, statistics

    public var storeKey: String { Storage.Key.onboardingVersion + "\(rawValue)" }
    public var version: Int { 1 }
}

public class AppManager: HoursShare.AppManager {
    public static let shared = AppManager()

    private var timer: Timer?

    // MARK: Onboarding

    public private(set) var onboardingIndices = [OnboardingIndices]()

    // MARK: HealthKit

    private lazy var healthStore = HKHealthStore()
    public private(set) var healthAccessGranted = false

    private var isSyncingSleep = false
    private var isSyncingWorkout = false

    // MARK: BackgroundTask

    private var observer: NSObjectProtocol?
    private let identifier = "cn.com.nostudio.napnap.backgroundFetch.identifier"
    private let operationQueue: OperationQueue = .init()

    override private init() {
        super.init()

        setupOnboardingIndices()
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
        guard isAutoSyncWorkout, !isSyncingWorkout else {
            completionHandler?()
            return
        }

        let from = Storage.default.lastSyncWorkoutDate?.addingTimeInterval(5 * 3600) ?? initialDate
        let to = Date()

        if from.distance(to: to) < 30 {
            completionHandler?()
            return
        }
        Storage.default.lastSyncWorkoutDate = to

        syncWorkout(from: from, to: to, completionHandler: completionHandler)
    }

    private func syncWorkout(from: Date, to: Date, completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else {
            completionHandler?()
            return
        }

        // 数据同步结束
        isSyncingSleep = true
        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            // 数据同步结束
            self?.isSyncingSleep = false

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
        Task {
            let category = await AppRealm.shared.healthCategory()

            for workout in workouts {
                let id = workout.uuid.uuidString
                guard await !AppRealm.shared.containsRecord(where: { $0.healthSampleUUIDString == id }) else { continue }

                let name = workout.workoutActivityType.name
                let emoji = workout.workoutActivityType.emoji

                var newRecord = RecordEntity(creationMode: .health, startAt: workout.startDate, endAt: workout.endDate)
                newRecord.healthSampleUUIDString = id

                if let event = await AppRealm.shared.getEvent(by: name, emoji: emoji) {
                    // 同步到日历
                    newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)
                } else {
                    let event = await EventEntity(emoji: emoji, name: name, hex: AppRealm.shared.nextHex, isSystem: true)
                    await AppRealm.shared.writeEvent(event, addTo: category)

                    await AppRealm.shared.writeRecord(newRecord, addTo: event)
                }
            }

            // 稍微延迟一下，等数据入库完成
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completionHandler?()
            }
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
        guard isAutoSyncSleep, !isSyncingSleep else {
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
        guard HKHealthStore.isHealthDataAvailable(), healthAccessGranted else {
            completionHandler?()
            return
        }
        // 开始同步数据
        isSyncingSleep = true
        let predicate = HKQuery.predicateForSamples(withStart: from, end: to, options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, error in
            // 数据同步结束
            self?.isSyncingSleep = false

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
        Task {
            let category = await AppRealm.shared.healthCategory()
            let name = R.string.localizable.sleep()
            let emoji = "🛌"
            var event: EventEntity
            if let entity = await AppRealm.shared.getEvent(by: name, emoji: emoji) {
                event = entity
            } else {
                event = EventEntity(emoji: emoji, name: name, hex: await AppRealm.shared.nextHex, isSystem: true)
                await AppRealm.shared.writeEvent(event, addTo: category)
            }

            var records = [RecordEntity]()
            for item in samples {
                guard let type = HKCategoryValueSleepAnalysis(rawValue: item.value), type == .inBed else { continue }

                let isContains = await AppRealm.shared.containsRecord { $0.startAt <= item.startDate && $0.endAt >= item.endDate }
                guard !isContains else { continue }

                // 当睡眠数据非连续时，进行合并，让数据完整
                if let last = records.last, last.endAt.distance(to: item.startDate) < 90 * 60 {
                    records[records.count - 1].endAt = item.endDate
                } else {
                    var record = RecordEntity(creationMode: .health, startAt: item.startDate, endAt: item.endDate)
                    record.healthSampleUUIDString = item.uuid.uuidString
                    records.append(record)
                }
            }
            // 过滤掉时间非连续，并且时长小于 5 分的数据
            let filtedRecord = records.filter { $0.milliseconds > 300 * 1000 }
            await AppRealm.shared.writeRecords(filtedRecord, addTo: event)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completionHandler?()
            }
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
