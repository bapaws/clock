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

    private var isPomodoroStopped: Bool = true
    private var isClockStopped: Bool = false
    private var isTimerStopped: Bool = true

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
    }

    override public func suspend() {
        ClockManager.shared.suspendTimer()
        PomodoroManager.shared.suspendTimer()
        TimerManager.shared.suspendTimer()

        isPomodoroStopped = true
        isClockStopped = true
        isTimerStopped = true
        audioPlayerQueue.async {
            self.audioPlayer?.stop()
        }
    }

    override public func resume() {
        switch page {
        case .pomodoro:
            isPomodoroStopped = false
            isClockStopped = true
            isTimerStopped = true

            PomodoroManager.shared.resumeTimer()
            ClockManager.shared.suspendTimer()
            TimerManager.shared.suspendTimer()
        case .clock:
            isPomodoroStopped = true
            isClockStopped = false
            isTimerStopped = true

            PomodoroManager.shared.suspendTimer()
            ClockManager.shared.resumeTimer()
            TimerManager.shared.suspendTimer()
        case .timer:
            isPomodoroStopped = true
            isClockStopped = true
            isTimerStopped = false

            PomodoroManager.shared.suspendTimer()
            ClockManager.shared.suspendTimer()
            TimerManager.shared.resumeTimer()
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
