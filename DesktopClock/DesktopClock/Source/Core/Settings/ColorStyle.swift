//
//  Colors.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/30.
//

import Foundation
import Neumorphic
import SwiftUI

public enum ColorType: String, CaseIterable {
    case classic, pink, orange, purple

    public static var title: String {
        R.string.localizable.colorThemes()
    }

    public var value: String {
        switch self {
        case .classic:
            R.string.localizable.classic()
        case .pink:
            R.string.localizable.pink()
        case .orange:
            R.string.localizable.orange()
        case .purple:
            R.string.localizable.purple()
        }
    }

    public var colors: Colors {
        switch self {
        case .classic:
            Colors.classic()
        case .pink:
            Colors(light: Color(hexadecimal6: 0xff96b6), dark: Color(hexadecimal6: 0xff96b6))
        case .orange:
            Colors(light: Color(hexadecimal6: 0xf58653), dark: Color(hexadecimal6: 0xf58653))
        case .purple:
            Colors(light: Color(hexadecimal6: 0x9a4cf4), dark: Color(hexadecimal6: 0x907dac))
        }
    }

    public var isPro: Bool {
        self != .classic
    }
}
