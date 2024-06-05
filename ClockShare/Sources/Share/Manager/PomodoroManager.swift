//
//  PomodoroManager.swift
//
//
//  Created by 张敏超 on 2023/12/22.
//

import AVFoundation
import Combine
import CoreHaptics
import Foundation
import SwiftUI

public enum PomodoroState: String, Codable {
    case none, focus, focusCompleted, shortBreak, longBreak
}

open class PomodoroBaseManager: ObservableObject {
    @AppStorage(Storage.Key.Pomodoro.focusMinutes, store: Storage.default.store)
    public var focusMinutes: Int = 25 {
        didSet {
            guard state == .none else { return }
            time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
        }
    }

    @AppStorage(Storage.Key.Pomodoro.shortBreakMinutes, store: Storage.default.store)
    public var shortBreakMinutes: Int = 5
    @AppStorage(Storage.Key.Pomodoro.longBreakMinutes, store: Storage.default.store)
    public var longBreakMinutes: Int = 20

    @AppStorage(Storage.Key.Pomodoro.longBreakMinutes, store: Storage.default.store)
    public var focusLoopCount: Int = 3

    @Published public private(set) var focusCount: Int = 0
    @Published public private(set) var state: PomodoroState {
        didSet { didSetState() }
    }

    private var engine: CHHapticEngine?

    public var timeInterval: TimeInterval = 1.0
    @Published public private(set) var time: Time = .focus

    private var timer: Timer?

    public init() {
        state = .none

        setup()
    }

    public func setup() {
        guard state == .none else { return }
        time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
    }

    open func didSetState() {
        timer?.invalidate()
        timer = nil

        withAnimation {
            #if DEBUG
                switch state {
                case .none:
                    time = Time(hour: 0, minute: 1, second: 9)
                    removeNotification()
                case .focus:
                    time = Time(hour: 0, minute: 12, second: 9)
                    // 开始专注，添加本地计时通知
                    addNotification()
                case .focusCompleted, .shortBreak:
                    time = Time(hour: 0, minute: 5, second: 0)
                case .longBreak:
                    time = Time(hour: 0, minute: 0, second: 6)
                }

            #else
                switch state {
                case .none:
                    time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
                case .focus:
                    time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
                    // 开始专注，添加本地计时通知
                    addNotification()
                case .focusCompleted:
                    time = Time(hour: shortBreakMinutes / 60, minute: shortBreakMinutes % 60, second: 0)
                case .shortBreak:
                    time = Time(hour: shortBreakMinutes / 60, minute: shortBreakMinutes % 60, second: 0)
                case .longBreak:
                    time = Time(hour: longBreakMinutes / 60, minute: longBreakMinutes % 60, second: 0)
                }
            #endif
        }
    }

    open func activityUpdate(time: Time) {
        fatalError()
    }
}

// MARK: Focus

public extension PomodoroBaseManager {
    func startFocus() {
        state = .focus
        restartFocusTimer()
    }

    func restartFocusTimer() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            withAnimation {
                self.time--
            }

            if self.time.seconds <= 0 {
                self.focusCount += 1
                self.state = .focusCompleted

                self.playFeedback()
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
}

// MARK: Short Break

public extension PomodoroBaseManager {
    func startShortBreak() {
        state = .shortBreak
        restartShortBreak()
    }

    func restartShortBreak() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            withAnimation {
                self.time--
            }

            if self.time.seconds <= 0 {
                self.state = .none
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
}

// MARK: Long Break

public extension PomodoroBaseManager {
    func startLongBreak() {
        state = .longBreak
        restartLongBreak()
    }

    func restartLongBreak() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            withAnimation {
                self.time--
            }

            if self.time.seconds <= 0 {
                self.state = .none
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
}

// MARK: - Timer

public extension PomodoroBaseManager {
    func stop() {
        state = .none
    }

    func suspendTimer() {
//        timer?.fireDate = .distantFuture
    }

    func resumeTimer() {
        guard let timer = timer else { return }
        time--
        timer.fireDate = Date()
    }
}

// MARK: Feedback

public extension PomodoroBaseManager {
    func playFeedback() {
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(soundID)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            AudioServicesPlaySystemSound(soundID)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let soundID = SystemSoundID(kSystemSoundID_Vibrate)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}

// MARK: Notification

extension PomodoroBaseManager {
    static let identifier = "com.bapaws.desktopclock.Pomodoro"

    func addNotification() {
        let current = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "AppName".localized
        if state == .focus {
            content.body = "FocusCompletedNotification".localized
        } else {
            content.body = "BreakCompletedNotification".localized
        }
        content.sound = .default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time.seconds), repeats: false)
        let request = UNNotificationRequest(identifier: PomodoroBaseManager.identifier, content: content, trigger: trigger)
        current.add(request)
    }

    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [PomodoroBaseManager.identifier])
    }
}

// MARK: -

public extension PomodoroBaseManager {
    var focusMinutesOptions: [Int] {
        var options = [Int]()
        var option = 5
        while option <= 60 {
            options.append(option)
            option += 5
        }
        option = 70
        while option <= 100 {
            options.append(option)
            option += 10
        }
        options.append(120)
        options.append(150)
        options.append(180)
        return options
    }

    var shortBreakMinuteOptions: [Int] {
        var options = [Int]()
        for index in 1 ... 5 {
            options.append(index)
        }
        var option = 10
        while option <= 60 {
            options.append(option)
            option += 5
        }
        return options
    }

    var longBreakMinuteOptions: [Int] {
        var options = [Int]()
        var option = 5
        while option <= 60 {
            options.append(option)
            option += 5
        }
        return options
    }
}
