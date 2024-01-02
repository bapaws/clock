//
//  Colors.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/31.
//

import Foundation
import SwiftUI

public struct Colors {
    var scheme: ColorScheme = .light

    // MARK: Light Theme

    let lightThemePrimary: Color
    let lightThemeSecondary: Color
    let lightThemeBackground: Color
    let lightThemeDarkShadow: Color
    let lightThemeLightShadow: Color

    // MARK: Dark Theme

    let darkThemePrimary: Color
    let darkThemeSecondary: Color
    let darkThemeBackground: Color
    let darkThemeDarkShadow: Color
    let darkThemeLightShadow: Color

    init(
        scheme: ColorScheme = .light,
        light: Color,
        dark: Color
    ) {
        self.scheme = scheme

        let lightSaturation = light.saturation
        let lightBrightness = light.brightness
        lightThemePrimary = light
        lightThemeSecondary = light.adjustSaturation(by: (1 - lightSaturation) * 0.5).adjustBrightness(by: lightBrightness * 0.2)
        lightThemeBackground = light.adjustSaturation(by: -lightSaturation * 0.8)

        let lightBackgroundSaturation = lightThemeBackground.saturation
        let lightBackgroundBrightness = lightThemeBackground.brightness
        lightThemeLightShadow = lightThemeBackground.adjustSaturation(by: -lightBackgroundSaturation * 0.8).adjustBrightness(by: (1 - lightBackgroundBrightness) * 0.8)
        lightThemeDarkShadow = lightThemeBackground.adjustBrightness(by: -lightBackgroundBrightness * 0.2)

        let darkSaturation = dark.saturation
        let darkBrightness = dark.brightness
        darkThemePrimary = dark
        darkThemeSecondary = dark.adjustSaturation(by: -darkSaturation * 0.2).adjustBrightness(by: -darkBrightness * 0.1)
        darkThemeBackground = Color(red: 0.188, green: 0.192, blue: 0.208)

        let darkBackgroundSaturation = darkThemeBackground.saturation
        let darkBackgroundBrightness = darkThemeBackground.brightness
        darkThemeLightShadow = darkThemeBackground.adjustSaturation(by: -darkBackgroundSaturation * 0.8).adjustBrightness(by: darkBackgroundBrightness * 0.2)
        darkThemeDarkShadow = darkThemeBackground.adjustBrightness(by: -darkBackgroundBrightness * 0.5)
    }

    init(
        scheme: ColorScheme = .light,
        lightThemePrimary: Color,
        lightThemeSecondary: Color,
        lightThemeBackground: Color,
        lightThemeDarkShadow: Color,
        lightThemeLightShadow: Color,
        darkThemePrimary: Color,
        darkThemeSecondary: Color,
        darkThemeBackground: Color,
        darkThemeDarkShadow: Color,
        darkThemeLightShadow: Color
    ) {
        self.scheme = scheme
        self.lightThemePrimary = lightThemePrimary
        self.lightThemeSecondary = lightThemeSecondary
        self.lightThemeBackground = lightThemeBackground
        self.lightThemeDarkShadow = lightThemeDarkShadow
        self.lightThemeLightShadow = lightThemeLightShadow
        self.darkThemePrimary = darkThemePrimary
        self.darkThemeSecondary = darkThemeSecondary
        self.darkThemeBackground = darkThemeBackground
        self.darkThemeDarkShadow = darkThemeDarkShadow
        self.darkThemeLightShadow = darkThemeLightShadow
    }
}

// MARK: Classic

public extension Colors {
    static func classic(scheme: ColorScheme = .light) -> Colors {
        Colors(
            scheme: scheme,
            lightThemePrimary: Color(red: 0.482, green: 0.502, blue: 0.549),
            lightThemeSecondary: Color.systemTeal,
            lightThemeBackground: Color(red: 0.925, green: 0.941, blue: 0.953),
            lightThemeDarkShadow: Color(red: 0.820, green: 0.851, blue: 0.902),
            lightThemeLightShadow: Color(red: 1.000, green: 1.000, blue: 1.000),
            darkThemePrimary: Color(red: 0.910, green: 0.910, blue: 0.910),
            darkThemeSecondary: Color.systemTeal,
            darkThemeBackground: Color(red: 0.188, green: 0.192, blue: 0.208),
            darkThemeDarkShadow: Color(red: 0.137, green: 0.137, blue: 0.137),
            darkThemeLightShadow: Color(red: 0.243, green: 0.247, blue: 0.275)
        )
    }
}

// MARK: Mode

public extension Colors {
    var primary: Color { scheme == .dark ? darkThemePrimary : lightThemePrimary }
    var secondary: Color { scheme == .dark ? darkThemeSecondary : lightThemeSecondary }
    var background: Color { scheme == .dark ? darkThemeBackground : lightThemeBackground }
    var darkShadow: Color { scheme == .dark ? darkThemeDarkShadow : lightThemeDarkShadow }
    var lightShadow: Color { scheme == .dark ? darkThemeLightShadow : lightThemeLightShadow }
}

// MARK: Color Helper

public extension Colors {
    private static func adjustBrightness(of color: Color, by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        brightness += CGFloat(amount)
        brightness = max(0, min(brightness, 1))

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }

    private static func adjustSaturation(of color: Color, by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        saturation += CGFloat(amount)
        saturation = max(0, min(saturation, 1))

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }

    private static func calculateLuminance(of color: Color) -> Double {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let g = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let b = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)

        return 0.2126 * Double(r) + 0.7152 * Double(g) + 0.0722 * Double(b)
    }
}

// MARK: Color Helper

public extension Color {
    var brightness: Double {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return brightness
    }

    var saturation: Double {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return saturation
    }

    var luminance: Double {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = red <= 0.03928 ? red / 12.92 : pow((red + 0.055) / 1.055, 2.4)
        let g = green <= 0.03928 ? green / 12.92 : pow((green + 0.055) / 1.055, 2.4)
        let b = blue <= 0.03928 ? blue / 12.92 : pow((blue + 0.055) / 1.055, 2.4)

        return 0.2126 * Double(r) + 0.7152 * Double(g) + 0.0722 * Double(b)
    }

    func adjustBrightness(by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        brightness += CGFloat(amount)
        brightness = max(0, min(brightness, 1))

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }

    func adjustSaturation(by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        saturation += CGFloat(amount)
        saturation = max(0, min(saturation, 1))

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}
