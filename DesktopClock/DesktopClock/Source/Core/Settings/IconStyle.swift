//
//  UIContents.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import Foundation
import SwiftUI

public enum IconType: String, CaseIterable {
    case text, emoji

    public static var title: String {
        R.string.localizable.iconType()
    }

    public var value: String {
        switch self {
        case .text:
            R.string.localizable.text()
        case .emoji:
            "Emoji"
        }
    }

    public var style: IconStyle {
        switch self {
        case .text:
            TextIconStyle()
        case .emoji:
            EmojiIconStyle()
        }
    }
}

public struct EmojiIconStyle: IconStyle {
    public let pomodoro: String = "🍅"
    public let clock: String = "🕰"
    public let timer: String = "⏲️"
    public let settings: String = "⚙️"
    public let start: String = "▶️"
    public let stop: String = "⏹️"
    public let pause: String = "⏸️"
    public let resume: String = "▶️"

    public let font: Font = .headline

    public var tabItemWidth: CGFloat {
        58
    }

    public var tabItemHeight: CGFloat {
        32
    }
}

public struct TextIconStyle: IconStyle {
    public var pomodoro: String {
        R.string.localizable.pomodoro()
    }

    public var clock: String {
        R.string.localizable.clock()
    }

    public var timer: String {
        R.string.localizable.timer()
    }

    public var settings: String {
        R.string.localizable.settings()
    }

    public var start: String = "开始"
    public var stop: String = "停止"
    public var pause: String = "暂停"
    public var resume: String = "继续"

    public let font: Font = .footnote

    public var tabItemWidth: CGFloat {
        86
    }

    public var tabItemHeight: CGFloat {
        32
    }
}
