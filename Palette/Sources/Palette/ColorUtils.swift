//
//  ColorUtils.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

struct ColorUtils {
    static let srgbToXyz = [
        [0.41233895, 0.35762064, 0.18051042],
        [0.2126, 0.7152, 0.0722],
        [0.01932141, 0.11916382, 0.95034478]
    ]

    static let whitePointD65 = [95.047, 100.0, 108.883]

    public static func y(from lstar: Double) -> Double {
        return 100.0 * labInvf(ft: (lstar + 16.0) / 116.0)
    }

    private static func labInvf(ft: Double) -> Double {
        let e = 216.0 / 24389.0
        let kappa = 24389.0 / 27.0
        let ft3 = ft * ft * ft
        if (ft3 > e) {
            return ft3
        } else {
            return (116 * ft - 16) / kappa
        }
    }

    /// Converts a color from linear RGB components to ARGB format.
    static func argb(from linrgb: [Double]) -> Int {
        let r = delinearized(rgbComponent: linrgb[0])
        let g = delinearized(rgbComponent: linrgb[1])
        let b = delinearized(rgbComponent: linrgb[2])
        return argb(red: r, green: g, blue: b)
    }

    /// Converts a color from XYZ to ARGB.
    public static func xyz(from argb: Int) -> [Double] {
        let r = linearized(rgbComponent: red(from: argb))
        let g = linearized(rgbComponent: green(from: argb))
        let b = linearized(rgbComponent: blue(from: argb))
        return MathUtils.matrixMultiply(row: [r, g, b], matrix: srgbToXyz)
    }

    /// Returns the alpha component of a color in ARGB format.
    public static func alpha(from argb: Int) -> Int {
        argb >> 24 & 255
    }

    /// Returns the red component of a color in ARGB format.
    public static func red(from argb: Int) -> Int {
        argb >> 16 & 255
    }

    /// Returns the green component of a color in ARGB format.
    public static func green(from argb: Int) -> Int {
        argb >> 8 & 255
    }

    /// Returns the blue component of a color in ARGB format.
    public static func blue(from argb: Int) -> Int {
        argb & 255
    }

    /// Returns whether a color in ARGB format is opaque.
    public static func isOpaque( argb: Int) -> Bool {
        alpha(from: argb) >= 255
    }

    /// Linearizes an RGB component.
    ///
    /// [rgbComponent] 0 <= rgb_component <= 255, represents R/G/B
    /// channel
    /// Returns 0.0 <= output <= 100.0, color channel converted to
    /// linear RGB space
    public static func linearized(rgbComponent: Int) -> Double {
        let normalized = Double(rgbComponent) / 255.0
        if (normalized <= 0.040449936) {
            return normalized / 12.92 * 100.0
        } else {
            return pow(Double(normalized + 0.055) / 1.055, 2.4) * 100.0
        }
    }

    /// Converts an L* value to an ARGB representation.
    ///
    /// [lstar] L* in L*a*b*
    /// Returns ARGB representation of grayscale color with lightness
    /// matching L*
    static func argb(from lstar: Double) -> Int {
        let y = y(from: lstar)
        let component = delinearized(rgbComponent: y)
        return argb(red: component, green: component, blue: component)
    }

    /// Delinearizes an RGB component.
    ///
    /// [rgbComponent] 0.0 <= rgb_component <= 100.0, represents linear
    /// R/G/B channel
    /// Returns 0 <= output <= 255, color channel converted to regular
    /// RGB space
    static func delinearized(rgbComponent: Double) -> Int {
      let normalized = rgbComponent / 100.0
      var delinearized = 0.0
      if (normalized <= 0.0031308) {
        delinearized = normalized * 12.92
      } else {
        delinearized = 1.055 * pow(normalized, 1.0 / 2.4) - 0.055
      }
        return MathUtils.clampInt(min: 0, max: 255, input: Int((delinearized * 255.0).rounded()))
    }

    /// Converts a color from RGB components to ARGB format.
    static func argb(red: Int, green: Int, blue: Int) -> Int {
      return 255 << 24 | (red & 255) << 16 | (green & 255) << 8 | blue & 255
    }

    /// Computes the L* value of a color in ARGB representation.
    ///
    /// [argb] ARGB representation of a color
    /// Returns L*, from L*a*b*, coordinate of the color
    static func lstar(from argb: Int) -> Double {
      let y = xyz(from: argb)[1]
        return 116.0 * labF(t: y / 100.0) - 16.0
    }

    private static func labF(t: Double) -> Double {
      let e = 216.0 / 24389.0
      let kappa = 24389.0 / 27.0
      if t > e {
        return pow(t, 1.0 / 3.0)
      } else {
        return (kappa * t + 16) / 116
      }
    }
}
