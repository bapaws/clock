//
//  Colors.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/31.
//

import Foundation
import Neumorphic
import SwiftUI
import SwiftUIX

public struct Colors: Codable {
    public var scheme: ColorScheme = .light

    // MARK: Light Theme

    let lightThemePrimary: UIColor
    let lightThemeSecondary: UIColor
    let lightThemeBackground: UIColor
    let lightThemeDarkShadow: UIColor
    let lightThemeLightShadow: UIColor

    // MARK: Dark Theme

    let darkThemePrimary: UIColor
    let darkThemeSecondary: UIColor
    let darkThemeBackground: UIColor
    let darkThemeDarkShadow: UIColor
    let darkThemeLightShadow: UIColor

    public init(
        scheme: ColorScheme = .light,
        light: Color,
        dark: Color
    ) {
        self.scheme = scheme

        lightThemePrimary = light.toUIColor() ?? UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        let lightSaturation = lightThemePrimary.saturation
        let lightBrightness = lightThemePrimary.brightness
        lightThemeSecondary = lightThemePrimary.adjustSaturation(by: (1 - lightSaturation) * 0.5).adjustBrightness(by: lightBrightness * 0.2)
        lightThemeBackground = lightThemePrimary.adjustSaturation(by: -lightSaturation * 0.8)

        let lightBackgroundSaturation = lightThemeBackground.saturation
        let lightBackgroundBrightness = lightThemeBackground.brightness
        lightThemeLightShadow = lightThemeBackground.adjustSaturation(by: -lightBackgroundSaturation * 0.8).adjustBrightness(by: (1 - lightBackgroundBrightness) * 0.8)
        lightThemeDarkShadow = lightThemeBackground.adjustBrightness(by: -lightBackgroundBrightness * 0.2)

        darkThemePrimary = dark.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        let darkSaturation = darkThemePrimary.saturation
        let darkBrightness = darkThemePrimary.brightness
        darkThemeSecondary = darkThemePrimary.adjustSaturation(by: -darkSaturation * 0.2).adjustBrightness(by: -darkBrightness * 0.1)
        darkThemeBackground = UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)

        let darkBackgroundSaturation = darkThemeBackground.saturation
        let darkBackgroundBrightness = darkThemeBackground.brightness
        darkThemeLightShadow = darkThemeBackground.adjustSaturation(by: -darkBackgroundSaturation * 0.8).adjustBrightness(by: darkBackgroundBrightness * 0.2)
        darkThemeDarkShadow = darkThemeBackground.adjustBrightness(by: -darkBackgroundBrightness * 0.5)
    }

    public init(
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
        self.lightThemePrimary = lightThemePrimary.toUIColor() ?? UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        self.lightThemeSecondary = lightThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.lightThemeBackground = lightThemeBackground.toUIColor() ?? UIColor(red: 0.925, green: 0.941, blue: 0.953, alpha: 1.0)
        self.lightThemeDarkShadow = lightThemeDarkShadow.toUIColor() ?? UIColor(red: 0.820, green: 0.851, blue: 0.902, alpha: 1.0)
        self.lightThemeLightShadow = lightThemeLightShadow.toUIColor() ?? UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.0)
        self.darkThemePrimary = darkThemePrimary.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        self.darkThemeSecondary = darkThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.darkThemeBackground = darkThemeBackground.toUIColor() ?? UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
        self.darkThemeDarkShadow = darkThemeDarkShadow.toUIColor() ?? UIColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.0)
        self.darkThemeLightShadow = darkThemeLightShadow.toUIColor() ?? UIColor(red: 0.243, green: 0.247, blue: 0.275, alpha: 1.0)
    }
}

// MARK: Codable

public extension Colors {
    private struct Argb: Codable {
        let alpha: Double
        let red: Double
        let green: Double
        let blue: Double

        init(uiColor: UIColor) {
            var alpha: CGFloat = 0.0
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            self.alpha = alpha
            self.red = red
            self.green = green
            self.blue = blue
        }

        var uiColor: UIColor {
            UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    private enum Scheme: String, Codable {
        case light, dark

        init(colorScheme: ColorScheme) {
            switch colorScheme {
            case .light:
                self = .light
            case .dark:
                self = .dark
            @unknown default:
                self = .light
            }
        }

        var colorScheme: ColorScheme {
            switch self {
            case .light:
                .light
            case .dark:
                .dark
            }
        }
    }

    private enum CodingKeys: String, CodingKey {
        case scheme
        case lightThemePrimary
        case lightThemeSecondary
        case lightThemeBackground
        case lightThemeDarkShadow
        case lightThemeLightShadow
        case darkThemePrimary
        case darkThemeSecondary
        case darkThemeBackground
        case darkThemeDarkShadow
        case darkThemeLightShadow
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scheme = try container.decode(Scheme.self, forKey: .scheme).colorScheme
        lightThemePrimary = try container.decode(Argb.self, forKey: .lightThemePrimary).uiColor
        lightThemeSecondary = try container.decode(Argb.self, forKey: .lightThemeSecondary).uiColor
        lightThemeBackground = try container.decode(Argb.self, forKey: .lightThemeBackground).uiColor
        lightThemeDarkShadow = try container.decode(Argb.self, forKey: .lightThemeDarkShadow).uiColor
        lightThemeLightShadow = try container.decode(Argb.self, forKey: .lightThemeLightShadow).uiColor
        darkThemePrimary = try container.decode(Argb.self, forKey: .darkThemePrimary).uiColor
        darkThemeSecondary = try container.decode(Argb.self, forKey: .darkThemeSecondary).uiColor
        darkThemeBackground = try container.decode(Argb.self, forKey: .darkThemeBackground).uiColor
        darkThemeDarkShadow = try container.decode(Argb.self, forKey: .darkThemeDarkShadow).uiColor
        darkThemeLightShadow = try container.decode(Argb.self, forKey: .darkThemeLightShadow).uiColor
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Scheme(colorScheme: scheme), forKey: .scheme)
        try container.encode(Argb(uiColor: lightThemePrimary), forKey: .lightThemePrimary)
        try container.encode(Argb(uiColor: lightThemeSecondary), forKey: .lightThemeSecondary)
        try container.encode(Argb(uiColor: lightThemeBackground), forKey: .lightThemeBackground)
        try container.encode(Argb(uiColor: lightThemeDarkShadow), forKey: .lightThemeDarkShadow)
        try container.encode(Argb(uiColor: lightThemeLightShadow), forKey: .lightThemeLightShadow)
        try container.encode(Argb(uiColor: darkThemePrimary), forKey: .darkThemePrimary)
        try container.encode(Argb(uiColor: darkThemeSecondary), forKey: .darkThemeSecondary)
        try container.encode(Argb(uiColor: darkThemeBackground), forKey: .darkThemeBackground)
        try container.encode(Argb(uiColor: darkThemeDarkShadow), forKey: .darkThemeDarkShadow)
        try container.encode(Argb(uiColor: darkThemeLightShadow), forKey: .darkThemeLightShadow)
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

    static func pink(scheme: ColorScheme = .light) -> Colors {
        Colors(light: Color(hexadecimal6: 0xff96b6), dark: Color(hexadecimal6: 0xff96b6))
    }

    static func orange(scheme: ColorScheme = .light) -> Colors {
        Colors(light: Color(hexadecimal6: 0xf58653), dark: Color(hexadecimal6: 0xf58653))
    }

    static func purple(scheme: ColorScheme = .light) -> Colors {
        Colors(light: Color(hexadecimal6: 0x9a4cf4), dark: Color(hexadecimal6: 0x907dac))
    }
}

// MARK: Mode

public extension Colors {
    var primary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemePrimary : lightThemePrimary }) }
    var secondary: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeSecondary : lightThemeSecondary }) }
    var background: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeBackground : lightThemeBackground }) }
    var darkShadow: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeDarkShadow : lightThemeDarkShadow }) }
    var lightShadow: Color { Color(uiColor: .init { $0.userInterfaceStyle == .dark ? darkThemeLightShadow : lightThemeLightShadow }) }
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
