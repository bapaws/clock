//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/1.
//

import Foundation
import SwiftUI

// MARK: HexObjectColors

public protocol HexObjectColors {
    var hex: HexObject? { get }
}

public extension HexObjectColors {
    var color: Color { hex!.color }
    var primary: Color { hex!.primary }
    var onPrimary: Color { hex!.onPrimary }
    var primaryContainer: Color { hex!.primaryContainer }
    var onPrimaryContainer: Color { hex!.onPrimaryContainer }
    var secondary: Color { hex!.secondary }
    var onSecondary: Color { hex!.onSecondary }
    var secondaryContainer: Color { hex!.secondaryContainer }
    var onSecondaryContainer: Color { hex!.onSecondaryContainer }
    var tertiary: Color { hex!.tertiary }
    var onTertiary: Color { hex!.onTertiary }
    var tertiaryContainer: Color { hex!.tertiaryContainer }
    var onTertiaryContainer: Color { hex!.onTertiaryContainer }
    var error: Color { hex!.error }
    var onError: Color { hex!.onError }
    var errorContainer: Color { hex!.errorContainer }
    var onErrorContainer: Color { hex!.onErrorContainer }
    var background: Color { hex!.background }
    var onBackground: Color { hex!.onBackground }
    var surface: Color { hex!.surface }
    var onSurface: Color { hex!.onSurface }
    var surfaceVariant: Color { hex!.surfaceVariant }
    var onSurfaceVariant: Color { hex!.onSurfaceVariant }
    var outline: Color { hex!.outline }
    var outlineVariant: Color { hex!.outlineVariant }
    var shadow: Color { hex!.shadow }
    var scrim: Color { hex!.scrim }
    var inverseSurface: Color { hex!.inverseSurface }
    var onInverseSurface: Color { hex!.onInverseSurface }
    var inversePrimary: Color { hex!.inversePrimary }

    var lightPrimary: Color { Color(argb: hex!.light!.primary) }
    var lightOnPrimary: Color { Color(argb: hex!.light!.onPrimary) }
    var lightPrimaryContainer: Color { Color(argb: hex!.light!.primaryContainer) }
    var lightOnPrimaryContainer: Color { Color(argb: hex!.light!.onPrimaryContainer) }
    var lightSecondary: Color { Color(argb: hex!.light!.secondary) }
    var lightOnSecondary: Color { Color(argb: hex!.light!.onSecondary) }
    var lightSecondaryContainer: Color { Color(argb: hex!.light!.secondaryContainer) }
    var lightOnSecondaryContainer: Color { Color(argb: hex!.light!.onSecondaryContainer) }
    var lightTertiary: Color { Color(argb: hex!.light!.tertiary) }
    var lightOnTertiary: Color { Color(argb: hex!.light!.onTertiary) }
    var lightTertiaryContainer: Color { Color(argb: hex!.light!.tertiaryContainer) }
    var lightOnTertiaryContainer: Color { Color(argb: hex!.light!.onTertiaryContainer) }
    var lightError: Color { Color(argb: hex!.light!.error) }
    var lightOnError: Color { Color(argb: hex!.light!.onError) }
    var lightErrorContainer: Color { Color(argb: hex!.light!.errorContainer) }
    var lightOnErrorContainer: Color { Color(argb: hex!.light!.onErrorContainer) }
    var lightBackground: Color { Color(argb: hex!.light!.background) }
    var lightOnBackground: Color { Color(argb: hex!.light!.onBackground) }
    var lightSurface: Color { Color(argb: hex!.light!.surface) }
    var lightOnSurface: Color { Color(argb: hex!.light!.onSurface) }
    var lightSurfaceVariant: Color { Color(argb: hex!.light!.surfaceVariant) }
    var lightOnSurfaceVariant: Color { Color(argb: hex!.light!.onSurfaceVariant) }
    var lightOutline: Color { Color(argb: hex!.light!.outline) }
    var lightOutlineVariant: Color { Color(argb: hex!.light!.outlineVariant) }
    var lightShadow: Color { Color(argb: hex!.light!.shadow) }
    var lightScrim: Color { Color(argb: hex!.light!.scrim) }
    var lightInverseSurface: Color { Color(argb: hex!.light!.inverseSurface) }
    var lightOnInverseSurface: Color { Color(argb: hex!.light!.onInverseSurface) }
    var lightInversePrimary: Color { Color(argb: hex!.light!.inversePrimary) }

    var darkPrimary: Color { Color(argb: hex!.dark!.primary) }
    var darkOnPrimary: Color { Color(argb: hex!.dark!.onPrimary) }
    var darkPrimaryContainer: Color { Color(argb: hex!.dark!.primaryContainer) }
    var darkOnPrimaryContainer: Color { Color(argb: hex!.dark!.onPrimaryContainer) }
    var darkSecondary: Color { Color(argb: hex!.dark!.secondary) }
    var darkOnSecondary: Color { Color(argb: hex!.dark!.onSecondary) }
    var darkSecondaryContainer: Color { Color(argb: hex!.dark!.secondaryContainer) }
    var darkOnSecondaryContainer: Color { Color(argb: hex!.dark!.onSecondaryContainer) }
    var darkTertiary: Color { Color(argb: hex!.dark!.tertiary) }
    var darkOnTertiary: Color { Color(argb: hex!.dark!.onTertiary) }
    var darkTertiaryContainer: Color { Color(argb: hex!.dark!.tertiaryContainer) }
    var darkOnTertiaryContainer: Color { Color(argb: hex!.dark!.onTertiaryContainer) }
    var darkError: Color { Color(argb: hex!.dark!.error) }
    var darkOnError: Color { Color(argb: hex!.dark!.onError) }
    var darkErrorContainer: Color { Color(argb: hex!.dark!.errorContainer) }
    var darkOnErrorContainer: Color { Color(argb: hex!.dark!.onErrorContainer) }
    var darkBackground: Color { Color(argb: hex!.dark!.background) }
    var darkOnBackground: Color { Color(argb: hex!.dark!.onBackground) }
    var darkSurface: Color { Color(argb: hex!.dark!.surface) }
    var darkOnSurface: Color { Color(argb: hex!.dark!.onSurface) }
    var darkSurfaceVariant: Color { Color(argb: hex!.dark!.surfaceVariant) }
    var darkOnSurfaceVariant: Color { Color(argb: hex!.dark!.onSurfaceVariant) }
    var darkOutline: Color { Color(argb: hex!.dark!.outline) }
    var darkOutlineVariant: Color { Color(argb: hex!.dark!.outlineVariant) }
    var darkShadow: Color { Color(argb: hex!.dark!.shadow) }
    var darkScrim: Color { Color(argb: hex!.dark!.scrim) }
    var darkInverseSurface: Color { Color(argb: hex!.dark!.inverseSurface) }
    var darkOnInverseSurface: Color { Color(argb: hex!.dark!.onInverseSurface) }
    var darkInversePrimary: Color { Color(argb: hex!.dark!.inversePrimary) }
}

// MARK: HexEntityColors

public protocol HexEntityColors {
    var hex: HexEntity? { get }
}

public extension HexEntityColors {
    var color: Color { hex!.color }
    var primary: Color { hex!.primary }
    var onPrimary: Color { hex!.onPrimary }
    var primaryContainer: Color { hex!.primaryContainer }
    var onPrimaryContainer: Color { hex!.onPrimaryContainer }
    var secondary: Color { hex!.secondary }
    var onSecondary: Color { hex!.onSecondary }
    var secondaryContainer: Color { hex!.secondaryContainer }
    var onSecondaryContainer: Color { hex!.onSecondaryContainer }
    var tertiary: Color { hex!.tertiary }
    var onTertiary: Color { hex!.onTertiary }
    var tertiaryContainer: Color { hex!.tertiaryContainer }
    var onTertiaryContainer: Color { hex!.onTertiaryContainer }
    var error: Color { hex!.error }
    var onError: Color { hex!.onError }
    var errorContainer: Color { hex!.errorContainer }
    var onErrorContainer: Color { hex!.onErrorContainer }
    var background: Color { hex!.background }
    var onBackground: Color { hex!.onBackground }
    var surface: Color { hex!.surface }
    var onSurface: Color { hex!.onSurface }
    var surfaceVariant: Color { hex!.surfaceVariant }
    var onSurfaceVariant: Color { hex!.onSurfaceVariant }
    var outline: Color { hex!.outline }
    var outlineVariant: Color { hex!.outlineVariant }
    var shadow: Color { hex!.shadow }
    var scrim: Color { hex!.scrim }
    var inverseSurface: Color { hex!.inverseSurface }
    var onInverseSurface: Color { hex!.onInverseSurface }
    var inversePrimary: Color { hex!.inversePrimary }

    var lightPrimary: Color { Color(argb: hex!.light!.primary) }
    var lightOnPrimary: Color { Color(argb: hex!.light!.onPrimary) }
    var lightPrimaryContainer: Color { Color(argb: hex!.light!.primaryContainer) }
    var lightOnPrimaryContainer: Color { Color(argb: hex!.light!.onPrimaryContainer) }
    var lightSecondary: Color { Color(argb: hex!.light!.secondary) }
    var lightOnSecondary: Color { Color(argb: hex!.light!.onSecondary) }
    var lightSecondaryContainer: Color { Color(argb: hex!.light!.secondaryContainer) }
    var lightOnSecondaryContainer: Color { Color(argb: hex!.light!.onSecondaryContainer) }
    var lightTertiary: Color { Color(argb: hex!.light!.tertiary) }
    var lightOnTertiary: Color { Color(argb: hex!.light!.onTertiary) }
    var lightTertiaryContainer: Color { Color(argb: hex!.light!.tertiaryContainer) }
    var lightOnTertiaryContainer: Color { Color(argb: hex!.light!.onTertiaryContainer) }
    var lightError: Color { Color(argb: hex!.light!.error) }
    var lightOnError: Color { Color(argb: hex!.light!.onError) }
    var lightErrorContainer: Color { Color(argb: hex!.light!.errorContainer) }
    var lightOnErrorContainer: Color { Color(argb: hex!.light!.onErrorContainer) }
    var lightBackground: Color { Color(argb: hex!.light!.background) }
    var lightOnBackground: Color { Color(argb: hex!.light!.onBackground) }
    var lightSurface: Color { Color(argb: hex!.light!.surface) }
    var lightOnSurface: Color { Color(argb: hex!.light!.onSurface) }
    var lightSurfaceVariant: Color { Color(argb: hex!.light!.surfaceVariant) }
    var lightOnSurfaceVariant: Color { Color(argb: hex!.light!.onSurfaceVariant) }
    var lightOutline: Color { Color(argb: hex!.light!.outline) }
    var lightOutlineVariant: Color { Color(argb: hex!.light!.outlineVariant) }
    var lightShadow: Color { Color(argb: hex!.light!.shadow) }
    var lightScrim: Color { Color(argb: hex!.light!.scrim) }
    var lightInverseSurface: Color { Color(argb: hex!.light!.inverseSurface) }
    var lightOnInverseSurface: Color { Color(argb: hex!.light!.onInverseSurface) }
    var lightInversePrimary: Color { Color(argb: hex!.light!.inversePrimary) }

    var darkPrimary: Color { Color(argb: hex!.dark!.primary) }
    var darkOnPrimary: Color { Color(argb: hex!.dark!.onPrimary) }
    var darkPrimaryContainer: Color { Color(argb: hex!.dark!.primaryContainer) }
    var darkOnPrimaryContainer: Color { Color(argb: hex!.dark!.onPrimaryContainer) }
    var darkSecondary: Color { Color(argb: hex!.dark!.secondary) }
    var darkOnSecondary: Color { Color(argb: hex!.dark!.onSecondary) }
    var darkSecondaryContainer: Color { Color(argb: hex!.dark!.secondaryContainer) }
    var darkOnSecondaryContainer: Color { Color(argb: hex!.dark!.onSecondaryContainer) }
    var darkTertiary: Color { Color(argb: hex!.dark!.tertiary) }
    var darkOnTertiary: Color { Color(argb: hex!.dark!.onTertiary) }
    var darkTertiaryContainer: Color { Color(argb: hex!.dark!.tertiaryContainer) }
    var darkOnTertiaryContainer: Color { Color(argb: hex!.dark!.onTertiaryContainer) }
    var darkError: Color { Color(argb: hex!.dark!.error) }
    var darkOnError: Color { Color(argb: hex!.dark!.onError) }
    var darkErrorContainer: Color { Color(argb: hex!.dark!.errorContainer) }
    var darkOnErrorContainer: Color { Color(argb: hex!.dark!.onErrorContainer) }
    var darkBackground: Color { Color(argb: hex!.dark!.background) }
    var darkOnBackground: Color { Color(argb: hex!.dark!.onBackground) }
    var darkSurface: Color { Color(argb: hex!.dark!.surface) }
    var darkOnSurface: Color { Color(argb: hex!.dark!.onSurface) }
    var darkSurfaceVariant: Color { Color(argb: hex!.dark!.surfaceVariant) }
    var darkOnSurfaceVariant: Color { Color(argb: hex!.dark!.onSurfaceVariant) }
    var darkOutline: Color { Color(argb: hex!.dark!.outline) }
    var darkOutlineVariant: Color { Color(argb: hex!.dark!.outlineVariant) }
    var darkShadow: Color { Color(argb: hex!.dark!.shadow) }
    var darkScrim: Color { Color(argb: hex!.dark!.scrim) }
    var darkInverseSurface: Color { Color(argb: hex!.dark!.inverseSurface) }
    var darkOnInverseSurface: Color { Color(argb: hex!.dark!.onInverseSurface) }
    var darkInversePrimary: Color { Color(argb: hex!.dark!.inversePrimary) }
}
