//
//  File.swift
//
//
//  Created by 张敏超 on 2024/7/30.
//

import Foundation
import SwiftUI
import UIKit

// MARK: Color

public extension HexEntity {
    var color: Color { Color(rgb: rgb) }

    var primary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.primary : self.light.primary) })
    }

    var onPrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onPrimary : self.light.onPrimary) })
    }

    var primaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.primaryContainer : self.light.primaryContainer) })
    }

    var onPrimaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onPrimaryContainer : self.light.onPrimaryContainer) })
    }

    var secondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.secondary : self.light.secondary) })
    }

    var onSecondary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSecondary : self.light.onSecondary) })
    }

    var secondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.secondaryContainer : self.light.secondaryContainer) })
    }

    var onSecondaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSecondaryContainer : self.light.onSecondaryContainer) })
    }

    var tertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.tertiary : self.light.tertiary) })
    }

    var onTertiary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onTertiary : self.light.onTertiary) })
    }

    var tertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.tertiaryContainer : self.light.tertiaryContainer) })
    }

    var onTertiaryContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onTertiaryContainer : self.light.onTertiaryContainer) })
    }

    var error: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.error : self.light.error) })
    }

    var onError: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onError : self.light.onError) })
    }

    var errorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.errorContainer : self.light.errorContainer) })
    }

    var onErrorContainer: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onErrorContainer : self.light.onErrorContainer) })
    }

    var background: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.background : self.light.background) })
    }

    var onBackground: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onBackground : self.light.onBackground) })
    }

    var surface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.surface : self.light.surface) })
    }

    var onSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSurface : self.light.onSurface) })
    }

    var surfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.surfaceVariant : self.light.surfaceVariant) })
    }

    var onSurfaceVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSurfaceVariant : self.light.onSurfaceVariant) })
    }

    var outline: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.outline : self.light.outline) })
    }

    var outlineVariant: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.outlineVariant : self.light.outlineVariant) })
    }

    var shadow: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.shadow : self.light.shadow) })
    }

    var scrim: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.scrim : self.light.scrim) })
    }

    var inverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.inverseSurface : self.light.inverseSurface) })
    }

    var onInverseSurface: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onInverseSurface : self.light.onInverseSurface) })
    }

    var inversePrimary: Color {
        Color(UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.inversePrimary : self.light.inversePrimary) })
    }

    var lightPrimary: Color { Color(argb: light.primary) }
    var lightOnPrimary: Color { Color(argb: light.onPrimary) }
    var lightPrimaryContainer: Color { Color(argb: light.primaryContainer) }
    var lightOnPrimaryContainer: Color { Color(argb: light.onPrimaryContainer) }
    var lightSecondary: Color { Color(argb: light.secondary) }
    var lightOnSecondary: Color { Color(argb: light.onSecondary) }
    var lightSecondaryContainer: Color { Color(argb: light.secondaryContainer) }
    var lightOnSecondaryContainer: Color { Color(argb: light.onSecondaryContainer) }
    var lightTertiary: Color { Color(argb: light.tertiary) }
    var lightOnTertiary: Color { Color(argb: light.onTertiary) }
    var lightTertiaryContainer: Color { Color(argb: light.tertiaryContainer) }
    var lightOnTertiaryContainer: Color { Color(argb: light.onTertiaryContainer) }
    var lightError: Color { Color(argb: light.error) }
    var lightOnError: Color { Color(argb: light.onError) }
    var lightErrorContainer: Color { Color(argb: light.errorContainer) }
    var lightOnErrorContainer: Color { Color(argb: light.onErrorContainer) }
    var lightBackground: Color { Color(argb: light.background) }
    var lightOnBackground: Color { Color(argb: light.onBackground) }
    var lightSurface: Color { Color(argb: light.surface) }
    var lightOnSurface: Color { Color(argb: light.onSurface) }
    var lightSurfaceVariant: Color { Color(argb: light.surfaceVariant) }
    var lightOnSurfaceVariant: Color { Color(argb: light.onSurfaceVariant) }
    var lightOutline: Color { Color(argb: light.outline) }
    var lightOutlineVariant: Color { Color(argb: light.outlineVariant) }
    var lightShadow: Color { Color(argb: light.shadow) }
    var lightScrim: Color { Color(argb: light.scrim) }
    var lightInverseSurface: Color { Color(argb: light.inverseSurface) }
    var lightOnInverseSurface: Color { Color(argb: light.onInverseSurface) }
    var lightInversePrimary: Color { Color(argb: light.inversePrimary) }

    var darkPrimary: Color { Color(argb: dark.primary) }
    var darkOnPrimary: Color { Color(argb: dark.onPrimary) }
    var darkPrimaryContainer: Color { Color(argb: dark.primaryContainer) }
    var darkOnPrimaryContainer: Color { Color(argb: dark.onPrimaryContainer) }
    var darkSecondary: Color { Color(argb: dark.secondary) }
    var darkOnSecondary: Color { Color(argb: dark.onSecondary) }
    var darkSecondaryContainer: Color { Color(argb: dark.secondaryContainer) }
    var darkOnSecondaryContainer: Color { Color(argb: dark.onSecondaryContainer) }
    var darkTertiary: Color { Color(argb: dark.tertiary) }
    var darkOnTertiary: Color { Color(argb: dark.onTertiary) }
    var darkTertiaryContainer: Color { Color(argb: dark.tertiaryContainer) }
    var darkOnTertiaryContainer: Color { Color(argb: dark.onTertiaryContainer) }
    var darkError: Color { Color(argb: dark.error) }
    var darkOnError: Color { Color(argb: dark.onError) }
    var darkErrorContainer: Color { Color(argb: dark.errorContainer) }
    var darkOnErrorContainer: Color { Color(argb: dark.onErrorContainer) }
    var darkBackground: Color { Color(argb: dark.background) }
    var darkOnBackground: Color { Color(argb: dark.onBackground) }
    var darkSurface: Color { Color(argb: dark.surface) }
    var darkOnSurface: Color { Color(argb: dark.onSurface) }
    var darkSurfaceVariant: Color { Color(argb: dark.surfaceVariant) }
    var darkOnSurfaceVariant: Color { Color(argb: dark.onSurfaceVariant) }
    var darkOutline: Color { Color(argb: dark.outline) }
    var darkOutlineVariant: Color { Color(argb: dark.outlineVariant) }
    var darkShadow: Color { Color(argb: dark.shadow) }
    var darkScrim: Color { Color(argb: dark.scrim) }
    var darkInverseSurface: Color { Color(argb: dark.inverseSurface) }
    var darkOnInverseSurface: Color { Color(argb: dark.onInverseSurface) }
    var darkInversePrimary: Color { Color(argb: dark.inversePrimary) }
}

// MARK: UIColor

public extension HexEntity {
    var uiColor: UIColor { UIColor(argb: rgb) }

    var uiPrimary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.primary : self.light.primary) }
    }

    var uiOnPrimary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onPrimary : self.light.onPrimary) }
    }

    var uiPrimaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.primaryContainer : self.light.primaryContainer) }
    }

    var uiOnPrimaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onPrimaryContainer : self.light.onPrimaryContainer) }
    }

    var uiSecondary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.secondary : self.light.secondary) }
    }

    var uiOnSecondary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSecondary : self.light.onSecondary) }
    }

    var uiSecondaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.secondaryContainer : self.light.secondaryContainer) }
    }

    var uiOnSecondaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSecondaryContainer : self.light.onSecondaryContainer) }
    }

    var uiTertiary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.tertiary : self.light.tertiary) }
    }

    var uiOnTertiary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onTertiary : self.light.onTertiary) }
    }

    var uiTertiaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.tertiaryContainer : self.light.tertiaryContainer) }
    }

    var uiOnTertiaryContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onTertiaryContainer : self.light.onTertiaryContainer) }
    }

    var uiError: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.error : self.light.error) }
    }

    var uiOnError: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onError : self.light.onError) }
    }

    var uiErrorContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.errorContainer : self.light.errorContainer) }
    }

    var uiOnErrorContainer: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onErrorContainer : self.light.onErrorContainer) }
    }

    var uiBackground: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.background : self.light.background) }
    }

    var uiOnBackground: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onBackground : self.light.onBackground) }
    }

    var uiSurface: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.surface : self.light.surface) }
    }

    var uiOnSurface: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSurface : self.light.onSurface) }
    }

    var uiSurfaceVariant: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.surfaceVariant : self.light.surfaceVariant) }
    }

    var uiOnSurfaceVariant: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onSurfaceVariant : self.light.onSurfaceVariant) }
    }

    var uiOutline: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.outline : self.light.outline) }
    }

    var uiOutlineVariant: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.outlineVariant : self.light.outlineVariant) }
    }

    var uiShadow: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.shadow : self.light.shadow) }
    }

    var uiScrim: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.scrim : self.light.scrim) }
    }

    var uiInverseSurface: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.inverseSurface : self.light.inverseSurface) }
    }

    var uiOnInverseSurface: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.onInverseSurface : self.light.onInverseSurface) }
    }

    var uiInversePrimary: UIColor {
        UIColor { UIColor(argb: $0.userInterfaceStyle == .dark ? self.dark.inversePrimary : self.light.inversePrimary) }
    }

    var uiLightPrimary: UIColor { UIColor(argb: light.primary) }
    var uiLightOnPrimary: UIColor { UIColor(argb: light.onPrimary) }
    var uiLightPrimaryContainer: UIColor { UIColor(argb: light.primaryContainer) }
    var uiLightOnPrimaryContainer: UIColor { UIColor(argb: light.onPrimaryContainer) }
    var uiLightSecondary: UIColor { UIColor(argb: light.secondary) }
    var uiLightOnSecondary: UIColor { UIColor(argb: light.onSecondary) }
    var uiLightSecondaryContainer: UIColor { UIColor(argb: light.secondaryContainer) }
    var uiLightOnSecondaryContainer: UIColor { UIColor(argb: light.onSecondaryContainer) }
    var uiLightTertiary: UIColor { UIColor(argb: light.tertiary) }
    var uiLightOnTertiary: UIColor { UIColor(argb: light.onTertiary) }
    var uiLightTertiaryContainer: UIColor { UIColor(argb: light.tertiaryContainer) }
    var uiLightOnTertiaryContainer: UIColor { UIColor(argb: light.onTertiaryContainer) }
    var uiLightError: UIColor { UIColor(argb: light.error) }
    var uiLightOnError: UIColor { UIColor(argb: light.onError) }
    var uiLightErrorContainer: UIColor { UIColor(argb: light.errorContainer) }
    var uiLightOnErrorContainer: UIColor { UIColor(argb: light.onErrorContainer) }
    var uiLightBackground: UIColor { UIColor(argb: light.background) }
    var uiLightOnBackground: UIColor { UIColor(argb: light.onBackground) }
    var uiLightSurface: UIColor { UIColor(argb: light.surface) }
    var uiLightOnSurface: UIColor { UIColor(argb: light.onSurface) }
    var uiLightSurfaceVariant: UIColor { UIColor(argb: light.surfaceVariant) }
    var uiLightOnSurfaceVariant: UIColor { UIColor(argb: light.onSurfaceVariant) }
    var uiLightOutline: UIColor { UIColor(argb: light.outline) }
    var uiLightOutlineVariant: UIColor { UIColor(argb: light.outlineVariant) }
    var uiLightShadow: UIColor { UIColor(argb: light.shadow) }
    var uiLightScrim: UIColor { UIColor(argb: light.scrim) }
    var uiLightInverseSurface: UIColor { UIColor(argb: light.inverseSurface) }
    var uiLightOnInverseSurface: UIColor { UIColor(argb: light.onInverseSurface) }
    var uiLightInversePrimary: UIColor { UIColor(argb: light.inversePrimary) }

    var uiDarkPrimary: UIColor { UIColor(argb: dark.primary) }
    var uiDarkOnPrimary: UIColor { UIColor(argb: dark.onPrimary) }
    var uiDarkPrimaryContainer: UIColor { UIColor(argb: dark.primaryContainer) }
    var uiDarkOnPrimaryContainer: UIColor { UIColor(argb: dark.onPrimaryContainer) }
    var uiDarkSecondary: UIColor { UIColor(argb: dark.secondary) }
    var uiDarkOnSecondary: UIColor { UIColor(argb: dark.onSecondary) }
    var uiDarkSecondaryContainer: UIColor { UIColor(argb: dark.secondaryContainer) }
    var uiDarkOnSecondaryContainer: UIColor { UIColor(argb: dark.onSecondaryContainer) }
    var uiDarkTertiary: UIColor { UIColor(argb: dark.tertiary) }
    var uiDarkOnTertiary: UIColor { UIColor(argb: dark.onTertiary) }
    var uiDarkTertiaryContainer: UIColor { UIColor(argb: dark.tertiaryContainer) }
    var uiDarkOnTertiaryContainer: UIColor { UIColor(argb: dark.onTertiaryContainer) }
    var uiDarkError: UIColor { UIColor(argb: dark.error) }
    var uiDarkOnError: UIColor { UIColor(argb: dark.onError) }
    var uiDarkErrorContainer: UIColor { UIColor(argb: dark.errorContainer) }
    var uiDarkOnErrorContainer: UIColor { UIColor(argb: dark.onErrorContainer) }
    var uiDarkBackground: UIColor { UIColor(argb: dark.background) }
    var uiDarkOnBackground: UIColor { UIColor(argb: dark.onBackground) }
    var uiDarkSurface: UIColor { UIColor(argb: dark.surface) }
    var uiDarkOnSurface: UIColor { UIColor(argb: dark.onSurface) }
    var uiDarkSurfaceVariant: UIColor { UIColor(argb: dark.surfaceVariant) }
    var uiDarkOnSurfaceVariant: UIColor { UIColor(argb: dark.onSurfaceVariant) }
    var uiDarkOutline: UIColor { UIColor(argb: dark.outline) }
    var uiDarkOutlineVariant: UIColor { UIColor(argb: dark.outlineVariant) }
    var uiDarkShadow: UIColor { UIColor(argb: dark.shadow) }
    var uiDarkScrim: UIColor { UIColor(argb: dark.scrim) }
    var uiDarkInverseSurface: UIColor { UIColor(argb: dark.inverseSurface) }
    var uiDarkOnInverseSurface: UIColor { UIColor(argb: dark.onInverseSurface) }
    var uiDarkInversePrimary: UIColor { UIColor(argb: dark.inversePrimary) }
}
