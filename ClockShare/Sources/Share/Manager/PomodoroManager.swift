//
//  PomodoroManager.swift
//
//
//  Created by 张敏超 on 2023/12/22.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

public enum PomodoroState {
    case none, focus, shortBreak, longBreak
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

            switch state {
            case .shortBreak:
                time = Time(hour: shortBreakMinutes / 60, minute: shortBreakMinutes % 60, second: 0)
            case .longBreak:
                time = Time(hour: longBreakMinutes / 60, minute: longBreakMinutes % 60, second: 0)
            default:
                time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
            }
        }
    }

    @Published public private(set) var time: Time
    private var timer: Timer?

    private init() {
        state = .none

        if let focusMinutes = Storage.default.store?.object(forKey: Storage.Key.Pomodoro.focusMinutes) as? Int {
            time = Time(hour: focusMinutes / 60, minute: focusMinutes % 60, second: 0)
        } else {
            time = .focus
        }
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
        option = 60
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

// MARK: - Timer

public extension PomodoroManager {
    func startFocus() {
        state = .focus
        let timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

            if self.time.seconds <= 0 {
                self.focusCount += 1
                if self.focusCount == self.focusLoopCount {
                    self.startLongBreak()
                } else {
                    self.startShortBreak()
                }
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func startShortBreak() {
        state = .shortBreak
        let timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

            if self.time.seconds <= 0 {
                self.startFocus()
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func startLongBreak() {
        state = .longBreak
        let timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.time--

            if self.time.seconds <= 0 {
                self.startFocus()
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func stop() {
        state = .none
    }
}
