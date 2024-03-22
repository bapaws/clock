//
//  Colors.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/9/27.
//

import Foundation
import SwiftUI

public extension Int {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(int)
    }
}

public extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init(rgb: Int) {
        let (r, g, b) = (rgb >> 16 & 0xFF, rgb >> 8 & 0xFF, rgb & 0xFF)
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }

    init(argb: Int) {
        let (a, r, g, b) = (argb >> 24, argb >> 16 & 0xFF, argb >> 8 & 0xFF, argb & 0xFF)
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func argb(from hex: String) -> Int? {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        return Int(int)
    }

    var foreground: Color {
        guard let cgColor = cgColor else { return .black }
        return Color(argb: UIColor(cgColor: cgColor).foreground.argb)
    }

    var contrast: Color {
        guard let cgColor = cgColor else { return .black }
        return Color(argb: UIColor(cgColor: cgColor).contrast.argb)
    }
}

public enum Colors {
    public static var primary: Color {
        Color(UIColor.primary)
    }

    public static var onPrimary: Color {
        Color(UIColor.onPrimary)
    }

    public static var primaryContainer: Color {
        Color(UIColor.primaryContainer)
    }

    public static var onPrimaryContainer: Color {
        Color(UIColor.onPrimaryContainer)
    }

    public static var secondary: Color {
        Color(UIColor.secondary)
    }

    public static var onSecondary: Color {
        Color(UIColor.onSecondary)
    }

    public static var secondaryContainer: Color {
        Color(UIColor.secondaryContainer)
    }

    public static var onSecondaryContainer: Color {
        Color(UIColor.onSecondaryContainer)
    }

    public static var tertiary: Color {
        Color(UIColor.tertiary)
    }

    public static var onTertiary: Color {
        Color(UIColor.onTertiary)
    }

    public static var tertiaryContainer: Color {
        Color(UIColor.tertiaryContainer)
    }

    public static var onTertiaryContainer: Color {
        Color(UIColor.onTertiaryContainer)
    }

    public static var error: Color {
        Color(UIColor.error)
    }

    public static var onError: Color {
        Color(UIColor.onError)
    }

    public static var errorContainer: Color {
        Color(UIColor.errorContainer)
    }

    public static var onErrorContainer: Color {
        Color(UIColor.onErrorContainer)
    }

    public static var outline: Color {
        Color(UIColor.outline)
    }

    public static var outlineVariant: Color {
        Color(UIColor.outlineVariant)
    }

    public static var background: Color {
        Color(UIColor.background)
    }

    public static var onBackground: Color {
        Color(UIColor.onBackground)
    }

    public static var surface: Color {
        Color(UIColor.surface)
    }

    public static var onSurface: Color {
        Color(UIColor.onSurface)
    }

    public static var surfaceVariant: Color {
        Color(UIColor.surfaceVariant)
    }

    public static var onSurfaceVariant: Color {
        Color(UIColor.onSurfaceVariant)
    }

    public static var inverseSurface: Color {
        Color(UIColor.inverseSurface)
    }

    public static var onInverseSurface: Color {
        Color(UIColor.onInverseSurface)
    }

    public static var inversePrimary: Color {
        Color(UIColor.inversePrimary)
    }

    public static var shadow: Color {
        Color(UIColor.shadow)
    }

    public static var scrim: Color {
        Color(UIColor.scrim)
    }
}

// MARK: -

public extension UIColor {
    private static var light = Scheme.light(argb: 0xFFFFFFFF)
    private static var dark = Scheme.dark(argb: 0xFF000000)

    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }

    convenience init(argb: Int) {
        let (a, r, g, b) = (argb >> 24, argb >> 16 & 0xFF, argb >> 8 & 0xFF, argb & 0xFF)
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
    }

    static var primary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).primary) }
    }

    static var onPrimary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onPrimary) }
    }

    static var primaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).primaryContainer) }
    }

    static var onPrimaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onPrimaryContainer) }
    }

    static var secondary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).secondary) }
    }

    static var onSecondary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onSecondary) }
    }

    static var secondaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).secondaryContainer) }
    }

    static var onSecondaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onSecondaryContainer) }
    }

    static var tertiary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).tertiary) }
    }

    static var onTertiary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onTertiary) }
    }

    static var tertiaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).tertiaryContainer) }
    }

    static var onTertiaryContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onTertiaryContainer) }
    }

    static var error: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).error) }
    }

    static var onError: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onError) }
    }

    static var errorContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).errorContainer) }
    }

    static var onErrorContainer: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onErrorContainer) }
    }

    static var background: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).background) }
    }

    static var onBackground: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onBackground) }
    }

    static var surface: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).surface) }
    }

    static var onSurface: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onSurface) }
    }

    static var surfaceVariant: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).surfaceVariant) }
    }

    static var onSurfaceVariant: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onSurfaceVariant) }
    }

    static var outline: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).outline) }
    }

    static var outlineVariant: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).outlineVariant) }
    }

    static var shadow: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).shadow) }
    }

    static var scrim: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).scrim) }
    }

    static var inverseSurface: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).inverseSurface) }
    }

    static var onInverseSurface: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).onInverseSurface) }
    }

    static var inversePrimary: UIColor {
        UIColor { UIColor(argb: ($0.userInterfaceStyle == .dark ? UIColor.dark : UIColor.light).inversePrimary) }
    }
}

// MARK: -

public extension UIColor {
    var foreground: UIColor {
        // 获取背景颜色的亮度值
        guard let components = cgColor.components else { return .black }

        let brightness = (components[0] * 299 + components[1] * 587 + components[2] * 114) / 1000

        // 根据背景颜色的亮度选择新颜色
        let foregroundColor: UIColor

        if brightness < 0.85 {
            foregroundColor = .white // 背景较暗，选择白色作为前景色
        } else {
            foregroundColor = .black // 背景较亮，选择黑色作为前景色
        }

        return foregroundColor
    }

    var contrast: UIColor {
        let contrastColor: UIColor

        // 获取背景色的HSB颜色空间表示
        guard let backgroundHSB = toHSB() else {
            return UIColor.black
        }

        // 调整饱和度和亮度
        var adjustedSaturation = backgroundHSB.saturation - 0.2
        var adjustedBrightness = backgroundHSB.brightness

        // 根据背景色的亮度选择调整方向
        if backgroundHSB.brightness > 0.5 {
            adjustedSaturation = backgroundHSB.saturation + 0.2
            adjustedBrightness -= 0.2
        } else {
            adjustedBrightness += 0.2
        }

        // 限制饱和度和亮度在合理范围内
        adjustedSaturation = max(0, min(1, adjustedSaturation))
        adjustedBrightness = max(0, min(1, adjustedBrightness))

        contrastColor = UIColor(hue: backgroundHSB.hue,
                                saturation: adjustedSaturation,
                                brightness: adjustedBrightness,
                                alpha: 1.0)

        return contrastColor
    }

    private struct HSBColor {
        let hue: CGFloat
        let saturation: CGFloat
        let brightness: CGFloat
    }

    private func toHSB() -> HSBColor? {
        // 将颜色转换为HSB颜色空间表示
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }

        return HSBColor(hue: hue, saturation: saturation, brightness: brightness)
    }
}

// MARK: -

public extension UIColor {
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
