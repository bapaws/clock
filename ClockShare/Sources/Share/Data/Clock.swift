//
//  Clock.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import SwiftUI

public enum ClockType: Int, CaseIterable {
    case pomodoro, clock, timer

    public var digitCount: Int {
        switch self {
        case .timer:
            6
        default:
            4
        }
    }

    public var colonCount: Int {
        switch self {
        case .timer:
            2
        default:
            1
        }
    }
}

public protocol Clock {
    var time: Time { get }
    var type: ClockType { get }
}
