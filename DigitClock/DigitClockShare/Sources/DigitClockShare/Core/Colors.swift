//
//  File.swift
//
//
//  Created by 张敏超 on 2024/1/21.
//

import ClockShare
import Foundation
import SwiftUI
import UIKit

public struct Colors: Codable, ClockShare.ThemeColors {
    public var scheme: ColorScheme = .light

    // MARK: Light Theme

    public let lightThemePrimary: UIColor
    public let lightThemeSecondary: UIColor
    public let lightThemeBackground: UIColor

    public var lightThemeSecondaryBackground: UIColor = .systemBackground
    public var lightThemeLabel: UIColor = .label
    public var lightThemeSecondaryLabel: UIColor = .secondaryLabel

    // MARK: Dark Theme

    public let darkThemePrimary: UIColor
    public let darkThemeSecondary: UIColor
    public let darkThemeBackground: UIColor

    public var darkThemeSecondaryBackground: UIColor = .systemBackground
    public var darkThemeLabel: UIColor = .label
    public var darkThemeSecondaryLabel: UIColor = .secondaryLabel

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

        darkThemePrimary = dark.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        let darkSaturation = darkThemePrimary.saturation
        let darkBrightness = darkThemePrimary.brightness
        darkThemeSecondary = darkThemePrimary.adjustSaturation(by: -darkSaturation * 0.2).adjustBrightness(by: -darkBrightness * 0.1)
        darkThemeBackground = UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
    }

    public init(
        scheme: ColorScheme = .light,
        lightThemePrimary: Color,
        lightThemeSecondary: Color,
        lightThemeBackground: Color,
        darkThemePrimary: Color,
        darkThemeSecondary: Color,
        darkThemeBackground: Color
    ) {
        self.scheme = scheme
        self.lightThemePrimary = lightThemePrimary.toUIColor() ?? UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        self.lightThemeSecondary = lightThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.lightThemeBackground = lightThemeBackground.toUIColor() ?? UIColor(red: 0.925, green: 0.941, blue: 0.953, alpha: 1.0)
        self.darkThemePrimary = darkThemePrimary.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        self.darkThemeSecondary = darkThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.darkThemeBackground = darkThemeBackground.toUIColor() ?? UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
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
        darkThemePrimary = try container.decode(Argb.self, forKey: .darkThemePrimary).uiColor
        darkThemeSecondary = try container.decode(Argb.self, forKey: .darkThemeSecondary).uiColor
        darkThemeBackground = try container.decode(Argb.self, forKey: .darkThemeBackground).uiColor
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Scheme(colorScheme: scheme), forKey: .scheme)
        try container.encode(Argb(uiColor: lightThemePrimary), forKey: .lightThemePrimary)
        try container.encode(Argb(uiColor: lightThemeSecondary), forKey: .lightThemeSecondary)
        try container.encode(Argb(uiColor: lightThemeBackground), forKey: .lightThemeBackground)
        try container.encode(Argb(uiColor: darkThemePrimary), forKey: .darkThemePrimary)
        try container.encode(Argb(uiColor: darkThemeSecondary), forKey: .darkThemeSecondary)
        try container.encode(Argb(uiColor: darkThemeBackground), forKey: .darkThemeBackground)
    }
}

// MARK: Classic

public extension Colors {
    static func classic(scheme: ColorScheme = .light) -> Colors {
        Colors(
            scheme: scheme,
            lightThemePrimary: Color.label,
            lightThemeSecondary: Color.secondaryLabel,
            lightThemeBackground: Color.systemBackground,
            darkThemePrimary: Color.label,
            darkThemeSecondary: Color.secondaryLabel,
            darkThemeBackground: Color.systemBackground
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

// MARK: -

public extension ColorType {
    var colors: Colors {
        switch self {
        case .classic:
            Colors.classic()
        case .pink:
            Colors.pink()
        case .orange:
            Colors.orange()
        case .purple:
            Colors.purple()
        }
    }

    func colors(scheme: ColorScheme = .light) -> Colors {
        switch self {
        case .classic:
            Colors.classic(scheme: scheme)
        case .pink:
            Colors.pink(scheme: scheme)
        case .orange:
            Colors.orange(scheme: scheme)
        case .purple:
            Colors.purple(scheme: scheme)
        }
    }
}
