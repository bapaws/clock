//
//  Scheme.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

public struct Scheme {
    public let primary: Int
    public let onPrimary: Int
    public let primaryContainer: Int
    public let onPrimaryContainer: Int
    public let secondary: Int
    public let onSecondary: Int
    public let secondaryContainer: Int
    public let onSecondaryContainer: Int
    public let tertiary: Int
    public let onTertiary: Int
    public let tertiaryContainer: Int
    public let onTertiaryContainer: Int
    public let error: Int
    public let onError: Int
    public let errorContainer: Int
    public let onErrorContainer: Int
    public let background: Int
    public let onBackground: Int
    public let surface: Int
    public let onSurface: Int
    public let surfaceVariant: Int
    public let onSurfaceVariant: Int
    public let outline: Int
    public let outlineVariant: Int
    public let shadow: Int
    public let scrim: Int
    public let inverseSurface: Int
    public let onInverseSurface: Int
    public let inversePrimary: Int

    public static func light(argb: Int) -> Scheme {
        light(from: CorePalette(argb: argb))
    }

    public static func dark(argb: Int) -> Scheme {
        dark(from: CorePalette(argb: argb))
    }

    static func light(from palette: CorePalette) -> Scheme {
        Scheme(
            primary: palette.primary.argb(from: 40),
            onPrimary: palette.primary.argb(from: 100),
            primaryContainer: palette.primary.argb(from: 90),
            onPrimaryContainer: palette.primary.argb(from: 10),
            secondary: palette.secondary.argb(from: 40),
            onSecondary: palette.secondary.argb(from: 100),
            secondaryContainer: palette.secondary.argb(from: 90),
            onSecondaryContainer: palette.secondary.argb(from: 10),
            tertiary: palette.tertiary.argb(from: 40),
            onTertiary: palette.tertiary.argb(from: 100),
            tertiaryContainer: palette.tertiary.argb(from: 90),
            onTertiaryContainer: palette.tertiary.argb(from: 10),
            error: palette.error.argb(from: 40),
            onError: palette.error.argb(from: 100),
            errorContainer: palette.error.argb(from: 90),
            onErrorContainer: palette.error.argb(from: 10),
            background: palette.neutral.argb(from: 99),
            onBackground: palette.neutral.argb(from: 10),
            surface: palette.neutral.argb(from: 99),
            onSurface: palette.neutral.argb(from: 10),
            surfaceVariant: palette.neutralVariant.argb(from: 90),
            onSurfaceVariant: palette.neutralVariant.argb(from: 30),
            outline: palette.neutralVariant.argb(from: 50),
            outlineVariant: palette.neutralVariant.argb(from: 80),
            shadow: palette.neutral.argb(from: 0),
            scrim: palette.neutral.argb(from: 0),
            inverseSurface: palette.neutral.argb(from: 20),
            onInverseSurface: palette.neutral.argb(from: 95),
            inversePrimary: palette.primary.argb(from: 80)
        )
    }

    static func dark(from palette: CorePalette) -> Scheme {
        Scheme(
            primary: palette.primary.argb(from: 80),
            onPrimary: palette.primary.argb(from: 20),
            primaryContainer: palette.primary.argb(from: 30),
            onPrimaryContainer: palette.primary.argb(from: 90),
            secondary: palette.secondary.argb(from: 80),
            onSecondary: palette.secondary.argb(from: 20),
            secondaryContainer: palette.secondary.argb(from: 30),
            onSecondaryContainer: palette.secondary.argb(from: 90),
            tertiary: palette.tertiary.argb(from: 80),
            onTertiary: palette.tertiary.argb(from: 20),
            tertiaryContainer: palette.tertiary.argb(from: 30),
            onTertiaryContainer: palette.tertiary.argb(from: 90),
            error: palette.error.argb(from: 80),
            onError: palette.error.argb(from: 20),
            errorContainer: palette.error.argb(from: 30),
            onErrorContainer: palette.error.argb(from: 80),
            background: palette.neutral.argb(from: 10),
            onBackground: palette.neutral.argb(from: 90),
            surface: palette.neutral.argb(from: 10),
            onSurface: palette.neutral.argb(from: 90),
            surfaceVariant: palette.neutralVariant.argb(from: 30),
            onSurfaceVariant: palette.neutralVariant.argb(from: 80),
            outline: palette.neutralVariant.argb(from: 60),
            outlineVariant: palette.neutralVariant.argb(from: 30),
            shadow: palette.neutral.argb(from: 0),
            scrim: palette.neutral.argb(from: 0),
            inverseSurface: palette.neutral.argb(from: 90),
            onInverseSurface: palette.neutral.argb(from: 20),
            inversePrimary: palette.primary.argb(from: 40)
        )
    }
}
