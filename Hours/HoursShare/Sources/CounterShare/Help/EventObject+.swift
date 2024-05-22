//
//  Task.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/4.
//

import Foundation
import SwiftUI
import SwiftUIX

public extension EventObject {
    var sectionTitle: String {
        if createdAt.isToday {
            return R.string.localizable.today()
        } else if createdAt.isYesterday {
            return R.string.localizable.yesterday()
        } else {
            return createdAt.formatted(date: .complete, time: .omitted)
        }
    }

    var totalTime: String {
        EventObject.format(milliseconds: milliseconds)
    }

    static func format(milliseconds: Int) -> String {
        let totalSeconds = Int((Double(milliseconds) / 1000).rounded())
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60 % 60
        let hours = totalSeconds / 3600
        var strings = [String]()
        if hours > 0 {
            strings.append("\(hours)h")
        }
        if minutes > 0 {
            strings.append("\(minutes)m")
        }
        if seconds > 0 {
            strings.append("\(seconds)s")
        }
        return strings.joined(separator: " ")
    }
}

// MARK: Help

public extension Int {
    var timeLengthText: String {
        let (day, hour, minute, second) = time
        var text = ""
        if second != 0 {
            text = "\(second)" + R.string.localizable.seconds()
        }
        if minute != 0 {
            text = "\(minute)" + R.string.localizable.minutes() + text
        }
        if hour != 0 {
            text = "\(hour)" + R.string.localizable.hours() + text
        }
        if day != 0 {
            text = "\(day)" + R.string.localizable.days() + text
        }
        return text
    }

    var shortTimeLengthText: String {
        let seconds = Double(self) / 1000
        if seconds < 60 {
            return "\(Int(seconds.rounded()))" + R.string.localizable.seconds()
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0

        let minutes = seconds / 60
        if minutes < 60 {
            return (formatter.string(from: NSNumber(value: minutes)) ?? "0") + R.string.localizable.minutes()
        }

        let hours = minutes / 60
        if hours < 24 {
            return (formatter.string(from: NSNumber(value: hours)) ?? "0") + R.string.localizable.hours()
        }

        let days = hours / 24
        return (formatter.string(from: NSNumber(value: days)) ?? "0") + R.string.localizable.days()
    }
}
