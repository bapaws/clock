//
//  ColorStyle.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/30.
//

import Foundation
import Neumorphic
import SwiftUI

public enum ColorType: String, CaseIterable {
    case light, dark, white, pink, purple

    public static var title: String {
        R.string.localizable.colorThemes()
    }

    public var value: String {
        switch self {
        case .light:
            R.string.localizable.light()
        case .dark:
            R.string.localizable.dark()
        case .white:
            R.string.localizable.white()
        case .pink:
            R.string.localizable.pink()
        case .purple:
            R.string.localizable.purple()
//            R.string.localizable.purple()
        }
    }

    public var style: ColorStyle {
        switch self {
        case .light:
            NeumorphicLightColors()
        case .dark:
            NeumorphicDarkColors()
        case .white:
            NeumorphicWhiteColors()
        case .pink:
            NeumorphicPinkColors()
        case .purple:
            NeumorphicPurpleColors()
        }
    }
}

public protocol ColorStyle {
    var primary: Color { get }
    var secondary: Color { get }
    var label: Color { get }
    var secondaryLabel: Color { get }
    var tertiaryLabel: Color { get }
    var quaternaryLabel: Color { get }
    var background: Color { get }
    var darkShadow: Color { get }
    var lightShadow: Color { get }
}

public extension ColorStyle {
    var secondary: Color { Color.white }
    var label: Color { Color.label }
    var secondaryLabel: Color { Color.secondaryLabel }
    var tertiaryLabel: Color { Color.tertiaryLabel }
    var quaternaryLabel: Color { Color.quaternaryLabel }
    var darkShadow: Color { Color.Neumorphic.darkShadow }
    var lightShadow: Color { Color.Neumorphic.lightShadow }
}

struct NeumorphicLightColors: ColorStyle {
    var primary: Color { Color.primary }

    var secondary: Color { Color.secondary }

    var background: Color { Color.Neumorphic.main }

    var secondaryLabel: Color { Color.Neumorphic.secondary }
}

struct NeumorphicDarkColors: ColorStyle {
    var primary: Color { Color.primary }

    var secondary: Color { Color.secondary }

    var background: Color { Color.Neumorphic.main }

    var secondaryLabel: Color { Color.Neumorphic.secondary }
}

struct NeumorphicWhiteColors: ColorStyle {
    var primary: Color { Color(hexadecimal6: 0x7B79FC) }

    var secondary: Color { Color(hexadecimal6: 0xE1E8F5) }

    var background: Color { Color(hexadecimal6: 0xF8F9FC) }

    var label: Color { Color(hexadecimal6: 0x303E57) }
}

struct NeumorphicPinkColors: ColorStyle {
    var primary: Color { Color(hexadecimal6: 0xFD4B6B) }

    var secondary: Color { Color.white }

    var background: Color { Color(hexadecimal6: 0xFF96B6) }

    var darkShadow: Color { Color(hexadecimal6: 0xFD4B6B) }

    var lightShadow: Color { Color(hexadecimal6: 0xFED0D9) }

    var secondaryLabel: Color { Color(hexadecimal6: 0xFFEFF8) }
}

struct NeumorphicPurpleColors: ColorStyle {
    var primary: Color { Color(hexadecimal6: 0xFD4B6B) }

    var secondary: Color { Color.white }

    var background: Color { Color(hexadecimal6: 0xFFBA87) }

    var darkShadow: Color { Color(hexadecimal6: 0xF58653) }

    var lightShadow: Color { Color(hexadecimal6: 0xFFEFBB) }

    var secondaryLabel: Color { Color(hexadecimal6: 0xFFEFBB) }
}
