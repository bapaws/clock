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

public class AppManager: ClockShare.AppBaseManager {
    public static let shared = AppManager()

    private var isPomodoroStopped: Bool = true
    private var isClockStopped: Bool = false
    private var isTimerStopped: Bool = true

    private var timer: Timer?
    @Published public var today: Date = Date().dateAtStartOf(.day)

    /// 可以记录的初始时间
    public let startAt = Date(year: 2023, month: 4, day: 7, hour: 0, minute: 0)


    private override init() {
        super.init()
    }

    public override func suspend() {
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

    public override func resume() {
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
