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
    var primary: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemePrimary)
        case .light: Color(uiColor: lightThemePrimary)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemePrimary : lightThemePrimary })
        }
    }

    var secondary: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemeSecondary)
        case .light: Color(uiColor: lightThemeSecondary)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondary : lightThemeSecondary })
        }
    }

    var background: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemeBackground)
        case .light: Color(uiColor: lightThemeBackground)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeBackground : lightThemeBackground })
        }
    }

    var secondaryBackground: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemeSecondaryBackground)
        case .light: Color(uiColor: lightThemeSecondaryBackground)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondaryBackground : lightThemeSecondaryBackground })
        }
    }

    var label: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemeLabel)
        case .light: Color(uiColor: lightThemeLabel)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeLabel : lightThemeLabel })
        }
    }

    var secondaryLabel: Color {
        switch mode {
        case .dark: Color(uiColor: darkThemeSecondaryLabel)
        case .light: Color(uiColor: lightThemeSecondaryLabel)
        case .system: Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondaryLabel : lightThemeSecondaryLabel })
        }
    }
}

// MARK: UIKit

public extension ThemeColors {
    var uiPrimary: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemePrimary : lightThemePrimary }
    }

    var uiSecondary: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemeSecondary : lightThemeSecondary }
    }

    var uiBackground: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemeBackground : lightThemeBackground }
    }

    var uiSecondaryBackground: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemeSecondaryBackground : lightThemeSecondaryBackground }
    }

    var uiLabel: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemeLabel : lightThemeLabel }
    }

    var uiSecondaryLabel: UIColor {
        .init { $0.userInterfaceStyle == .dark ? darkThemeSecondaryLabel : lightThemeSecondaryLabel }
    }
}
