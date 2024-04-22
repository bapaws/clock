//
//  ColorType.swift
//
//
//  Created by 张敏超 on 2024/1/11.
//

import Foundation
import SwiftUI

public enum ColorType: String, CaseIterable, Codable {
    case classic, pink, orange, purple

    public var isPro: Bool {
        self != .classic
    }
}

public protocol ThemeColors {
    var mode: DarkMode { get set }

    // MARK: Light Theme

    var lightThemePrimary: UIColor { get }
    var lightThemeSecondary: UIColor { get }
    var lightThemeBackground: UIColor { get }
    var lightThemeSecondaryBackground: UIColor { get }

    var lightThemeLabel: UIColor { get }
    var lightThemeSecondaryLabel: UIColor { get }

    // MARK: Dark Theme

    var darkThemePrimary: UIColor { get }
    var darkThemeSecondary: UIColor { get }
    var darkThemeBackground: UIColor { get }
    var darkThemeSecondaryBackground: UIColor { get }

    var darkThemeLabel: UIColor { get }
    var darkThemeSecondaryLabel: UIColor { get }

    init(
        mode: DarkMode,
        light: Color,
        dark: Color
    )
}

public extension ThemeColors {
    var primary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemePrimary : lightThemePrimary }) }
    var secondary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondary : lightThemeSecondary }) }
    var background: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeBackground : lightThemeBackground }) }
    var secondaryBackground: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? lightThemeSecondaryBackground : darkThemeSecondaryBackground }) }

    var label: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeLabel : lightThemeLabel }) }
    var secondaryLabel: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondaryLabel : lightThemeSecondaryLabel }) }
}
