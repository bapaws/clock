//
//  PaletteGenerator.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import CoreGraphics
import CoreImage
import Foundation
import SwiftUI

public struct PaletteGenerator {
    var argb: Int?
    var image: UIImage?

    public init(hex: String) {
        var argb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&argb)
        self.argb = Int(argb)
    }

    public init(argb: Int) {
        self.argb = argb
    }

    public init(image: UIImage) {
        self.image = image
    }

    private func scheme(
        for argb: Int,
        colorScheme: ColorScheme = .light
    ) -> Scheme? {
        switch colorScheme {
        case .dark:
            return Scheme.dark(argb: argb)
        default:
            return Scheme.light(argb: argb)
        }
    }

    public func scheme(colorScheme: ColorScheme = .light, completion: @escaping (Scheme?) -> Void) {
        DispatchQueue.global().async {
            guard let color = primaryARGB else { return completion(nil) }

            let result = scheme(for: color, colorScheme: colorScheme)
            return completion(result)
        }
    }
}

public extension PaletteGenerator {
    var primaryARGB: Int? {
        argb ?? PaletteGenerator.color(from: image)
    }

    static func color(from image: UIImage?) -> Int? {
        guard let cgImage = image?.cgImage else { return nil }

        var pixelData: [UInt8] = [0, 0, 0, 0]
        pixelData.withUnsafeMutableBytes { pointer in
            if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
               let context = CGContext(
                   data: pointer.baseAddress,
                   width: 1,
                   height: 1,
                   bitsPerComponent: 8,
                   bytesPerRow: 4,
                   space: colorSpace,
                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
               )
            {
                context.draw(cgImage, in: CGRectMake(0, 0, 1, 1))
            }
        }

        return ColorUtils.argb(red: Int(pixelData[0]), green: Int(pixelData[1]), blue: Int(pixelData[2]))
    }

    func colors(
        colorScheme: ColorScheme = .light
    ) -> PaletteColors? {
        guard let color = primaryARGB else { return nil }
        return PaletteColors(color: color, colorScheme: colorScheme)
    }
}

// MARK: -

public struct PaletteColors {
    let primary: Color
    let onPrimary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color
    let secondary: Color
    let onSecondary: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color
    let tertiary: Color
    let onTertiary: Color
    let tertiaryContainer: Color
    let onTertiaryContainer: Color
    let error: Color
    let onError: Color
    let errorContainer: Color
    let onErrorContainer: Color
    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
    let surfaceVariant: Color
    let onSurfaceVariant: Color
    let outline: Color
    let outlineVariant: Color
    let shadow: Color
    let scrim: Color
    let inverseSurface: Color
    let onInverseSurface: Color
    let inversePrimary: Color
    let surfaceTint: Color

    init(
        primary: Color,
        onPrimary: Color,
        primaryContainer: Color,
        onPrimaryContainer: Color,
        secondary: Color,
        onSecondary: Color,
        secondaryContainer: Color,
        onSecondaryContainer: Color,
        tertiary: Color,
        onTertiary: Color,
        tertiaryContainer: Color,
        onTertiaryContainer: Color,
        error: Color,
        onError: Color,
        errorContainer: Color,
        onErrorContainer: Color,
        outline: Color,
        outlineVariant: Color,
        background: Color,
        onBackground: Color,
        surface: Color,
        onSurface: Color,
        surfaceVariant: Color,
        onSurfaceVariant: Color,
        inverseSurface: Color,
        onInverseSurface: Color,
        inversePrimary: Color,
        shadow: Color,
        scrim: Color,
        surfaceTint: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.primaryContainer = primaryContainer
        self.onPrimaryContainer = onPrimaryContainer
        self.secondary = secondary
        self.onSecondary = onSecondary
        self.secondaryContainer = secondaryContainer
        self.onSecondaryContainer = onSecondaryContainer
        self.tertiary = tertiary
        self.onTertiary = onTertiary
        self.tertiaryContainer = tertiaryContainer
        self.onTertiaryContainer = onTertiaryContainer
        self.error = error
        self.onError = onError
        self.errorContainer = errorContainer
        self.onErrorContainer = onErrorContainer
        self.outline = outline
        self.outlineVariant = outlineVariant
        self.background = background
        self.onBackground = onBackground
        self.surface = surface
        self.onSurface = onSurface
        self.surfaceVariant = surfaceVariant
        self.onSurfaceVariant = onSurfaceVariant
        self.inverseSurface = inverseSurface
        self.onInverseSurface = onInverseSurface
        self.inversePrimary = inversePrimary
        self.shadow = shadow
        self.scrim = scrim
        self.surfaceTint = surfaceTint
    }

    public init(color: Int, colorScheme: ColorScheme) {
        var scheme: Scheme
        switch colorScheme {
        case .dark:
            scheme = Scheme.dark(argb: color)
        default:
            scheme = Scheme.light(argb: color)
        }

        self.init(
            primary: Color(argb: scheme.primary),
            onPrimary: Color(argb: scheme.onPrimary),
            primaryContainer: Color(argb: scheme.primaryContainer),
            onPrimaryContainer: Color(argb: scheme.onPrimaryContainer),
            secondary: Color(argb: scheme.secondary),
            onSecondary: Color(argb: scheme.onSecondary),
            secondaryContainer: Color(argb: scheme.secondaryContainer),
            onSecondaryContainer: Color(argb: scheme.onSecondaryContainer),
            tertiary: Color(argb: scheme.tertiary),
            onTertiary: Color(argb: scheme.onTertiary),
            tertiaryContainer: Color(argb: scheme.tertiaryContainer),
            onTertiaryContainer: Color(argb: scheme.onTertiaryContainer),
            error: Color(argb: scheme.error),
            onError: Color(argb: scheme.onError),
            errorContainer: Color(argb: scheme.errorContainer),
            onErrorContainer: Color(argb: scheme.onErrorContainer),
            outline: Color(argb: scheme.outline),
            outlineVariant: Color(argb: scheme.outlineVariant),
            background: Color(argb: scheme.background),
            onBackground: Color(argb: scheme.onBackground),
            surface: Color(argb: scheme.surface),
            onSurface: Color(argb: scheme.onSurface),
            surfaceVariant: Color(argb: scheme.surfaceVariant),
            onSurfaceVariant: Color(argb: scheme.onSurfaceVariant),
            inverseSurface: Color(argb: scheme.inverseSurface),
            onInverseSurface: Color(argb: scheme.onInverseSurface),
            inversePrimary: Color(argb: scheme.inversePrimary),
            shadow: Color(argb: scheme.shadow),
            scrim: Color(argb: scheme.scrim),
            surfaceTint: Color(argb: scheme.primary)
        )
    }
}
