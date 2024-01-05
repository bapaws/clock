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

public enum PomodoroState {
    case none, focus, focusCompleted, shortBreak, longBreak
}

public class PomodoroManager: ObservableObject {
    public static let shared = PomodoroManager()

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
        didSet {
            timer?.invalidate()
            timer = nil

            #if DEBUG
            switch state {
            case .focusCompleted, .shortBreak:
                time = Time(hour: 0, minute: 5, second: 0)
            case .longBreak:
                time = Time(hour: 0, minute: 0, second: 6)
            default:
                time = Time(hour: 0, minute: 0, second: 9)
            }
            #else
            switch state {
            case .focusCompleted, .shortBreak:
                time = Time(hour: shortBreakMinutes / 60, minute: shortBreakMinutes % 60, second: 0)
            case .longBreak:
                time = Time(hour: longBreakMinutes / 60, minute: longBreakMinutes % 60, second: 0)
            default:
                time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
            }
            #endif
        }
    }

    private var engine: CHHapticEngine?

    public var timeInterval: TimeInterval = 1.0
    @Published public private(set) var time: Time = .focus
    private var timer: Timer?

    private init() {
        state = .none

        setup()
    }

    public func setup() {
        guard state == .none else { return }
        time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
    }
}

// MARK: -

public extension PomodoroManager {
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

// MARK: Focus

public extension PomodoroManager {
    func startFocus() {
        state = .focus
        restartFocusTimer()
    }

    func restartFocusTimer() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

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

public extension PomodoroManager {
    func startShortBreak() {
        state = .shortBreak
        restartShortBreak()
    }

    func restartShortBreak() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

            if self.time.seconds <= 0 {
                self.state = .none
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
}

// MARK: Long Break

public extension PomodoroManager {
    func startLongBreak() {
        state = .longBreak
        restartLongBreak()
    }

    func restartLongBreak() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

            if self.time.seconds <= 0 {
                self.state = .focus
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
}

// MARK: - Timer

public extension PomodoroManager {
    func stop() {
        state = .none
    }

    func suspendTimer() {
        timer?.fireDate = .distantFuture
    }

    func resumeTimer() {
        guard let timer = timer else { return }
        time--
        timer.fireDate = Date()
    }
}

// MARK: Feedback

public extension PomodoroManager {
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
