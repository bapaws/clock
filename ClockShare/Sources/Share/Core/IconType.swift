//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/10.
//

import Foundation
import SwiftUI

public enum IconType: String, CaseIterable {
    case text, emoji

    public var style: IconStyle {
        switch self {
        case .text:
            TextIconStyle()
        case .emoji:
            EmojiIconStyle()
        }
    }

    public var isPro: Bool {
        self != .text
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
        "Pomodoro"
    }

    public var clock: String {
        "Clock"
    }

    public var timer: String {
        "Timer"
    }

    public var settings: String {
        "Settings"
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
