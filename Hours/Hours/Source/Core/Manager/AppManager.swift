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

    private var isSyncingSleep = false
    private var isSyncingWorkout = false

    // MARK: BackgroundTask

    private var observer: NSObjectProtocol?
    private let identifier = "cn.com.nostudio.napnap.backgroundFetch.identifier"
    private let operationQueue: OperationQueue = .init()

    // MARK: New Record Duration Picker(min)

    public var recordDurations: [Int] {
        [5, 10, 15, 20, 30, 45, 60, 90, 120, 180, 360, 480, 600]
    }

    override private init() {
        super.init()

        setupOnboardingIndices()
        if !onboardingIndices.contains(.health) {
            requestHealthAccess()
        }

        if !onboardingIndices.contains(.calendar) {
            requestCalendarAccess()
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

// MARK: Version

public extension AppManager {
    func fetchAppStoreVersion() async -> String? {
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let url = URL(string: "https://itunes.apple.com/cn/lookup?bundleId=\(bundleID)")
        else {
            return nil
        }

        do {
            let session = URLSession(configuration: .ephemeral)
            let (data, _) = try await session.data(from: url)
            let result = try JSONDecoder().decode(ItunesLookupResult.self, from: data)
            return result.results?.first?.version
        } catch {
            debugPrint(error)
            return nil
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

    func openHealthSettings() { // 其他情况直接跳转设置，重新设置
        guard let healthURL = URL(string: "App-prefs:HEALTH&path=SOURCES"),
              UIApplication.shared.canOpenURL(healthURL)
        else {
            return
        }

        if UIApplication.shared.canOpenURL(healthURL) {
            UIApplication.shared.open(healthURL)
        } else if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }

    var healthReadTypes: Set<HKObjectType> {
        [
            HKCategoryType(.sleepAnalysis),
            HKQuantityType.workoutType(),
        ]
    }

    func getRequestHealthStatus(completion: ((Bool) -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion?(false)
            return
        }

        healthStore.getRequestStatusForAuthorization(toShare: [], read: healthReadTypes) { status, _ in
            switch status {
            case .unknown:
                debugPrint("unknown")
            case .shouldRequest:
                debugPrint("shouldRequest")
            case .unnecessary:
                debugPrint("unnecessary")
            @unknown default:
                debugPrint("@unknown default")
            }
            completion?(status == .shouldRequest)
        }
    }

    func requestHealthAccess(completion: ((Bool) -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion?(false)
            return
        }

        // 授权回调中，无法判断用户是否授权，回调第一个参数表示是否成功
        // 无法获取读取权限状态，只能获取写数据状态
        // https://developer.apple.com/documentation/healthkit/hkhealthstore/1614154-authorizationstatus
        healthStore.requestAuthorization(toShare: nil, read: healthReadTypes) { [weak self] success, _ in
            if success {
                self?.enableObservedSleepAnalysis()
                self?.enableObservedWorkout()

                self?.autoSyncWorkout()
                self?.autoSyncSleep()
            }

            DispatchQueue.main.async {
                completion?(success)
            }
        }
    }

    func autoSyncHealth(completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable() else {
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
        guard HKHealthStore.isHealthDataAvailable() else { return }

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
        guard !isSyncingWorkout else {
            completionHandler?()
            return
        }

        let from = Storage.default.lastSyncWorkoutDate?.addingTimeInterval(-12 * 3600) ?? initialDate
        let to = Date()

        if from.distance(to: to) < 30 {
            completionHandler?()
            return
        }
        Storage.default.lastSyncWorkoutDate = to

        syncWorkout(from: from, to: to, completionHandler: completionHandler)
    }

    private func syncWorkout(from: Date, to: Date, completionHandler: (() -> Void)? = nil) {
        guard HKHealthStore.isHealthDataAvailable() else {
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

    private func saveWorkouts(_ workouts: [HKWorkout], completionHandler: (() -> Void)? = nil) {
        Task {
            let category = await AppRealm.shared.healthCategory()

            for workout in workouts {
                let id = workout.uuid.uuidString
                guard await !AppRealm.shared.containsRecord(where: { $0.healthSampleUUIDString == id }) else { continue }

                let eventID = workout.workoutActivityType.id
                let name = workout.workoutActivityType.name
                let emoji = workout.workoutActivityType.emoji

                var newRecord = RecordEntity(creationMode: .health, startAt: workout.startDate, endAt: workout.endDate)
                newRecord.healthSampleUUIDString = id

                if let eventID, let event = await AppRealm.shared.getEvent(by: eventID) {
                    newRecord.calendarEventIdentifier = await AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)
                } else if let event = await AppRealm.shared.getEvent(by: name, emoji: emoji) { // 兼容 1.6.6 之前的版本
                    // 同步到日历
                    newRecord.calendarEventIdentifier = await AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)
                } else {
                    let event = EventEntity(id: eventID, emoji: emoji, name: name, hex: .random, isSystem: true)
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
        guard HKHealthStore.isHealthDataAvailable() else { return }

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
        guard !isSyncingSleep else {
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
        guard HKHealthStore.isHealthDataAvailable() else {
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
            let name = L10n.sleep
            let emoji = "🛌"
            var event: EventEntity
            if let entity = await AppRealm.shared.getEvent(by: AppRealm.sleepEventID) {
                event = entity
            } else if let entity = await AppRealm.shared.getEvent(by: name, emoji: emoji) { // 兼容 1.6.6 之前的版本
                event = entity
            } else {
                event = EventEntity(id: AppRealm.sleepEventID, emoji: emoji, name: name, hex: .random, isSystem: true)
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

// MARK: - TimingEntity

public extension TimingEntity {
    var timerInterval: ClosedRange<Date> {
        time.initialDate ... date.addingTimeInterval(AppManager.shared.maximumRecordedTime)
    }
}
