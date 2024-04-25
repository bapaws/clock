//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import AVFoundation
import ClockShare
import Foundation

public class DigitalAppManager: ClockShare.AppBaseManager {
    public static let shared = DigitalAppManager()
    
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
}
