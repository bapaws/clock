//
//  Time.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import Dependencies
import Foundation
import SwiftUI

public struct Time: Equatable {
    @Dependency(\.date.now) var now

    public enum Meridiem: String {
        case am = "AM", pm = "PM"
    }

    public var hour: Int
    public var minute: Int
    public var second: Int
    public var millisecond: Int

    public private(set) var date: Date
    public init(date: Date = Date()) {
        self.date = date

        let components = Calendar.current.dateComponents([.hour, .minute, .second, .nanosecond], from: date)
        self.second = components.second ?? 0
        self.minute = components.minute ?? 25
        self.hour = components.hour ?? 12
        self.millisecond = (components.nanosecond ?? 0) / 1000000
    }

    public init(date: Date = Date(), hour: Int, minute: Int, second: Int, millisecond: Int = 0) {
        self.date = date

        self.millisecond = millisecond % 1000
        self.second = (second + millisecond / 1000) % 60
        self.minute = (minute + second / 60 + millisecond / 1000) % 60
        self.hour = (hour + minute / 60 + second / 3600 + millisecond / 1000) % 24
    }
}

public extension Time {
    static var zero: Time {
        #if DEBUG
        Time(hour: 0, minute: 0, second: 0)
        #else
        Time(hour: 0, minute: 0, second: 0)
        #endif
    }

    static var shortBreak: Time {
        #if DEBUG
        Time(hour: 0, minute: 0, second: 30)
        #else
        Time(hour: 0, minute: 5, second: 0)
        #endif
    }

    static var longBreak: Time {
        #if DEBUG
        Time(hour: 0, minute: 1, second: 0)
        #else
        Time(hour: 0, minute: 25, second: 0)
        #endif
    }

    static var focus: Time {
        #if DEBUG
        Time(hour: 0, minute: 1, second: 5)
        #else
        Time(hour: 0, minute: 25, second: 0)
        #endif
    }
}

// MARK: - Equatable

public extension Time {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second == rhs.second && lhs.millisecond == rhs.millisecond
    }
}

// MARK: Digit

public extension Time {
    // MARK: Time Format

    var hour24Tens: Int {
        (seconds / 3600) % 24 / 10
    }

    var hour24Ones: Int {
        (seconds / 3600) % 24 % 10
    }

    var hour12Tens: Int {
        (seconds / 3600) % 12 / 10
    }

    var hour12Ones: Int {
        (seconds / 3600) % 12 % 10
    }

    var meridiem: Meridiem {
        (seconds / 3600) % 24 > 12 ? .pm : .am
    }

    // MARK: Digit

    var hourTens: Int {
        (seconds / 3600) / 10
    }

    var hourOnes: Int {
        (seconds / 3600) % 10
    }

    var minuteTens: Int {
        seconds / 60 % 60 / 10
    }

    var minuteOnes: Int {
        seconds / 60 % 60 % 10
    }

    var secondTens: Int {
        seconds % 60 / 10
    }

    var secondOnes: Int {
        seconds % 60 % 10
    }

    // MARK: Length

    var seconds: Int {
        Int((Double(milliseconds) / 1000).rounded())
    }

    var milliseconds: Int {
        hour * 3600000 + minute * 60000 + second * 1000 + millisecond
    }
}

// MARK: Clock

public extension Time {
    mutating func toDate(_ date: Date? = nil) {
        self.date = date ?? now

        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: self.date)
        second = components.second ?? 0
        minute = components.minute ?? 25
        hour = components.hour ?? 12
        millisecond = (components.nanosecond ?? 0) / 1000000
    }
}

// MARK: Pomodoro

public extension Time {
    static postfix func -- (lhs: inout Self) {
        let now = lhs.now
        // Timer 间隔时间不准确，四舍五入
        let distance = Int((lhs.date.distance(to: now) * 1000).rounded())
        let millisecond = lhs.milliseconds - distance

        lhs.date = now

        lhs.millisecond = millisecond % 1000
        lhs.second = (millisecond / 1000) % 60
        lhs.minute = (millisecond / 60000) % 60
        lhs.hour = millisecond / 3600000
    }
}

// MARK: Timer

public extension Time {
    static postfix func ++ (lhs: inout Time) {
        let now = lhs.now
        let distance = Int((lhs.date.distance(to: now) * 1000).rounded())
        let millisecond = lhs.milliseconds + distance

        lhs.date = now

        lhs.millisecond = millisecond % 1000
        lhs.second = (millisecond / 1000) % 60
        lhs.minute = (millisecond / 60000) % 60
        lhs.hour = millisecond / 3600000
    }

    mutating func pause() {
        self++
    }

    mutating func resume() {
        date = now
        self++
    }
}

// MARK: Half

public extension Time {
    var halfSeconds: Int {
        (hour * 3600 + minute * 60 + second) * 2
    }
}
