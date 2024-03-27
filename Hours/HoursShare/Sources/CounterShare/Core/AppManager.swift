//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import AVFoundation
import ClockShare
import Foundation
import RealmSwift
import SwiftUI

public class AppManager: ClockShare.AppBaseManager {
    public static let shared = AppManager()


    private var timer: Timer?
    @Published public var today: Date = Date().dateAtStartOf(.day)

    @AppStorage(Storage.Key.timingMode, store: Storage.default.store)
    public var timingMode: TimingMode = .timer

    @AppStorage(Storage.Key.minimumRecordedTime, store: Storage.default.store)
    public var minimumRecordedTime: TimeInterval = 60

    /// 可以记录的初始时间
    public let initialDate = Date(year: 2023, month: 4, day: 7, hour: 0, minute: 0)

    override private init() {
        super.init()

        isPomodoroStopped = false
        isTimerStopped = false
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
