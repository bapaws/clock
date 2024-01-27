//
//  PomodoroState.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/11.
//

import ClockShare
import Foundation

public extension PomodoroState {
    var value: String {
        switch self {
        case .focus:
            R.string.localizable.focus()
        case .shortBreak, .longBreak:
            R.string.localizable.break()
        default:
            ""
        }
    }
}
