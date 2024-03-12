//
//  UIContents.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import Foundation
import SwiftUI

public extension IconType {
    static var title: String {
        R.string.localizable.iconType()
    }

    var value: String {
        switch self {
        case .text:
            R.string.localizable.text()
        case .emoji:
            "Emoji"
        }
    }
}

public extension TextIconStyle {
    var pomodoro: String {
        R.string.localizable.pomodoro()
    }

    var clock: String {
        R.string.localizable.clock()
    }

    var timer: String {
        R.string.localizable.timer()
    }

    var settings: String {
        R.string.localizable.settings()
    }
}
