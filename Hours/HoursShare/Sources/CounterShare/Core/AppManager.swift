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
    public var minimumRecordedTime: TimeInterval = 0

    /// 最长记录时间，单位小时
    @AppStorage(Storage.Key.maximumRecordedTime, store: Storage.default.store)
    public var maximumRecordedTime: TimeInterval = 6 * 60 * 60

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

    let eventStore = EKEventStore()
    @Published public var calendarAccessGranted: Bool = false
    var deleteEventIdentifiers = Map<String, Int>()

    /// 可以记录的初始时间
    public let initialDate = Date(year: 2023, month: 1, day: 1, hour: 0, minute: 0)

    override public init() {
        super.init()
        Storage.default.store.removeObject(forKey: Storage.Key.timingMode)

        isPomodoroStopped = false
        isTimerStopped = false

        requestCalendarAccess()
    }
}
