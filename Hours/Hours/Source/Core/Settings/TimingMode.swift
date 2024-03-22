//
//  TimingMode.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import HoursShare

public extension TimingMode {
    static var title: String {
        R.string.localizable.timingMode()
    }

    var value: String {
        switch self {
        case .pomodoro:
            R.string.localizable.pomodoro()
        case .timer:
            R.string.localizable.timer()
        }
    }

    var icon: String {
        switch self {
        case .timer:
            "infinity.circle"
        case .pomodoro:
            "timer"
        }
    }
}
