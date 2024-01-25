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
    var scheme: ColorScheme { get set }

    // MARK: Light Theme

    var lightThemePrimary: UIColor { get }
    var lightThemeSecondary: UIColor { get }
    var lightThemeBackground: UIColor { get }

    // MARK: Dark Theme

    var darkThemePrimary: UIColor { get }
    var darkThemeSecondary: UIColor { get }
    var darkThemeBackground: UIColor { get }

    init(
        scheme: ColorScheme,
        light: Color,
        dark: Color
    )
}

public extension ThemeColors {
    var primary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemePrimary : lightThemePrimary }) }
    var secondary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondary : lightThemeSecondary }) }
    var background: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeBackground : lightThemeBackground }) }
}
