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
    public var mode: DarkMode = .light

    // MARK: Light Theme

    public let lightThemePrimary: UIColor
    public let lightThemeSecondary: UIColor
    public let lightThemeBackground: UIColor
    public let lightThemeSecondaryBackground: UIColor

    public let lightThemeLabel: UIColor
    public let lightThemeSecondaryLabel: UIColor

    // MARK: Dark Theme

    public let darkThemePrimary: UIColor
    public let darkThemeSecondary: UIColor
    public let darkThemeBackground: UIColor
    public let darkThemeSecondaryBackground: UIColor

    public let darkThemeLabel: UIColor
    public let darkThemeSecondaryLabel: UIColor

    public init(
        mode: DarkMode = .light,
        light: Color,
        dark: Color
    ) {
        self.mode = mode

        lightThemePrimary = light.toUIColor() ?? UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        let lightSaturation = lightThemePrimary.saturation
        let lightBrightness = lightThemePrimary.brightness
        lightThemeSecondary = lightThemePrimary.adjustSaturation(by: (1 - lightSaturation) * 0.5).adjustBrightness(by: lightBrightness * 0.2)
        lightThemeBackground = lightThemePrimary.adjustSaturation(by: -lightSaturation * 0.8)
        lightThemeSecondaryBackground = .systemBackground

        darkThemePrimary = dark.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        let darkSaturation = darkThemePrimary.saturation
        let darkBrightness = darkThemePrimary.brightness
        darkThemeSecondary = darkThemePrimary.adjustSaturation(by: -darkSaturation * 0.2).adjustBrightness(by: -darkBrightness * 0.1)
        darkThemeBackground = UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
        darkThemeSecondaryBackground = .systemBackground

        lightThemeLabel = .label
        lightThemeSecondaryLabel = .secondaryLabel
        darkThemeLabel = .label
        darkThemeSecondaryLabel = .secondaryLabel
    }

    public init(
        mode: DarkMode = .light,
        lightThemePrimary: Color,
        lightThemeSecondary: Color,
        lightThemeBackground: Color,
        lightThemeLabel: Color,
        lightThemeSecondaryLabel: Color,
        lightThemeSecondaryBackground: Color,
        darkThemePrimary: Color,
        darkThemeSecondary: Color,
        darkThemeBackground: Color,
        darkThemeLabel: Color,
        darkThemeSecondaryLabel: Color,
        darkThemeSecondaryBackground: Color
    ) {
        self.mode = mode
        self.lightThemePrimary = lightThemePrimary.toUIColor() ?? UIColor(red: 0.482, green: 0.502, blue: 0.549, alpha: 1.0)
        self.lightThemeSecondary = lightThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.lightThemeBackground = lightThemeBackground.toUIColor() ?? UIColor(red: 0.925, green: 0.941, blue: 0.953, alpha: 1.0)
        self.lightThemeLabel = lightThemeLabel.toUIColor() ?? .label
        self.lightThemeSecondaryLabel = lightThemeSecondaryLabel.toUIColor() ?? .secondaryLabel
        self.lightThemeSecondaryBackground = lightThemeSecondaryBackground.toUIColor() ?? .systemBackground
        self.darkThemeLabel = darkThemeLabel.toUIColor() ?? .label
        self.darkThemeSecondaryLabel = darkThemeSecondaryLabel.toUIColor() ?? .secondaryLabel
        self.darkThemePrimary = darkThemePrimary.toUIColor() ?? UIColor(red: 0.910, green: 0.910, blue: 0.910, alpha: 1.0)
        self.darkThemeSecondary = darkThemeSecondary.toUIColor() ?? UIColor.systemTeal
        self.darkThemeBackground = darkThemeBackground.toUIColor() ?? UIColor(red: 0.188, green: 0.192, blue: 0.208, alpha: 1.0)
        self.darkThemeSecondaryBackground = darkThemeSecondaryBackground.toUIColor() ?? .systemBackground
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

    private enum CodingKeys: String, CodingKey {
        case mode
        case lightThemePrimary
        case lightThemeSecondary
        case lightThemeBackground
        case lightThemeLabel
        case lightThemeSecondaryLabel
        case lightThemeSecondaryBackground
        case darkThemePrimary
        case darkThemeSecondary
        case darkThemeBackground
        case darkThemeLabel
        case darkThemeSecondaryLabel
        case darkThemeSecondaryBackground
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mode = try container.decode(DarkMode.self, forKey: .mode)
        lightThemePrimary = try container.decode(Argb.self, forKey: .lightThemePrimary).uiColor
        lightThemeSecondary = try container.decode(Argb.self, forKey: .lightThemeSecondary).uiColor
        lightThemeBackground = try container.decode(Argb.self, forKey: .lightThemeBackground).uiColor
        lightThemeLabel = try container.decode(Argb.self, forKey: .lightThemeLabel).uiColor
        lightThemeSecondaryLabel = try container.decode(Argb.self, forKey: .lightThemeSecondaryLabel).uiColor
        lightThemeSecondaryBackground = try container.decode(Argb.self, forKey: .lightThemeSecondaryBackground).uiColor
        darkThemePrimary = try container.decode(Argb.self, forKey: .darkThemePrimary).uiColor
        darkThemeSecondary = try container.decode(Argb.self, forKey: .darkThemeSecondary).uiColor
        darkThemeBackground = try container.decode(Argb.self, forKey: .darkThemeBackground).uiColor
        darkThemeLabel = try container.decode(Argb.self, forKey: .darkThemeLabel).uiColor
        darkThemeSecondaryLabel = try container.decode(Argb.self, forKey: .darkThemeSecondaryLabel).uiColor
        darkThemeSecondaryBackground = try container.decode(Argb.self, forKey: .darkThemeSecondaryBackground).uiColor
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mode, forKey: .mode)
        try container.encode(Argb(uiColor: lightThemePrimary), forKey: .lightThemePrimary)
        try container.encode(Argb(uiColor: lightThemeSecondary), forKey: .lightThemeSecondary)
        try container.encode(Argb(uiColor: lightThemeBackground), forKey: .lightThemeBackground)
        try container.encode(Argb(uiColor: lightThemeLabel), forKey: .lightThemeLabel)
        try container.encode(Argb(uiColor: lightThemeSecondaryLabel), forKey: .lightThemeSecondaryLabel)
        try container.encode(Argb(uiColor: lightThemeSecondaryBackground), forKey: .lightThemeSecondaryBackground)
        try container.encode(Argb(uiColor: darkThemePrimary), forKey: .darkThemePrimary)
        try container.encode(Argb(uiColor: darkThemeSecondary), forKey: .darkThemeSecondary)
        try container.encode(Argb(uiColor: darkThemeBackground), forKey: .darkThemeBackground)
        try container.encode(Argb(uiColor: darkThemeLabel), forKey: .darkThemeLabel)
        try container.encode(Argb(uiColor: darkThemeSecondaryLabel), forKey: .darkThemeSecondaryLabel)
        try container.encode(Argb(uiColor: darkThemeSecondaryBackground), forKey: .darkThemeSecondaryBackground)
    }
}

// MARK: Classic

public extension Colors {
    static func classic(mode: DarkMode = .light) -> Colors {
        let dark = UITraitCollection(userInterfaceStyle: .dark)
        let light = UITraitCollection(userInterfaceStyle: .light)
        let darkPrimary = Color(UIColor.systemMint.resolvedColor(with: dark))
        let lightPrimary = Color(UIColor.systemMint.resolvedColor(with: light))
        let darkSecondary = Color(UIColor.systemTeal.resolvedColor(with: dark))
        let lightSecondary = Color(UIColor.systemTeal.resolvedColor(with: light))
        let darkBackground = Color(UIColor.secondarySystemBackground.resolvedColor(with: dark))
        let darkSecondaryLabel = Color(UIColor.secondaryLabel.resolvedColor(with: dark))
        let lightSecondaryLabel = Color(UIColor.secondaryLabel.resolvedColor(with: light))
        let darkSecondaryBackground = Color(UIColor.systemBackground.resolvedColor(with: dark))
        let lightSecondaryBackground = Color(UIColor.systemBackground.resolvedColor(with: light))
        return Colors(
            mode: mode,
            lightThemePrimary: lightPrimary,
            lightThemeSecondary: lightSecondary,
            lightThemeBackground: Color(argb: 0xfff3f3ed),
            lightThemeLabel: Color(white: 0.2),
            lightThemeSecondaryLabel: lightSecondaryLabel,
            lightThemeSecondaryBackground: lightSecondaryBackground,
            darkThemePrimary: darkPrimary,
            darkThemeSecondary: darkSecondary,
            darkThemeBackground: darkBackground,
            darkThemeLabel: Color(white: 0.85),
            darkThemeSecondaryLabel: darkSecondaryLabel,
            darkThemeSecondaryBackground: darkSecondaryBackground
        )
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
        default:
            fatalError()
        }
    }

    func colors(mode: DarkMode = .light) -> Colors {
        switch self {
        case .classic:
            Colors.classic(mode: mode)
        default:
            fatalError()
        }
    }
}
