//
//  Cam16.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

struct Cam16 {
    /// Like red, orange, yellow, green, etc.
    var hue: Double

    /// Informally, colorfulness / color intensity. Like saturation in HSL,
    /// except perceptually accurate.
    var chroma: Double

    /// Lightness
    var j: Double

    /// Brightness ratio of lightness to white point's lightness
    var q: Double

    /// Colorfulness
    var m: Double

    /// Saturation ratio of chroma to white point's chroma
    var s: Double

    /// CAM16-UCS J coordinate
    var jstar: Double

    /// CAM16-UCS a coordinate
    var astar: Double

    /// CAM16-UCS b coordinate
    var bstar: Double

    init(hue: Double, chroma: Double, j: Double, q: Double, m: Double, s: Double, jstar: Double, astar: Double, bstar: Double) {
        self.hue = hue
        self.chroma = chroma
        self.j = j
        self.q = q
        self.m = m
        self.s = s
        self.jstar = jstar
        self.astar = astar
        self.bstar = bstar
    }

    init(argb: Int, viewingConditions: ViewingConditions = ViewingConditions.sRgb) {
        // Transform ARGB int to XYZ
        let xyz = ColorUtils.xyz(from: argb)
        let x = xyz[0]
        let y = xyz[1]
        let z = xyz[2]

        // Transform XYZ to 'cone'/'rgb' responses

        let rC = 0.401288 * x + 0.650173 * y - 0.051461 * z
        let gC = -0.250268 * x + 1.204414 * y + 0.045854 * z
        let bC = -0.002079 * x + 0.048952 * y + 0.953127 * z

        // Discount illuminant
        let rD = viewingConditions.rgbD[0] * rC
        let gD = viewingConditions.rgbD[1] * gC
        let bD = viewingConditions.rgbD[2] * bC

        // chromatic adaptation
        let rAF = pow(viewingConditions.fl * abs(rD) / 100.0, 0.42)
        let gAF = pow(viewingConditions.fl * abs(gD) / 100.0, 0.42)
        let bAF = pow(viewingConditions.fl * abs(bD) / 100.0, 0.42)
        let rA = MathUtils.signum(num: rD) * 400.0 * rAF / (rAF + 27.13)
        let gA = MathUtils.signum(num: gD) * 400.0 * gAF / (gAF + 27.13)
        let bA = MathUtils.signum(num: bD) * 400.0 * bAF / (bAF + 27.13)

        // redness-greenness
        let a = (11.0 * rA + -12.0 * gA + bA) / 11.0
        // yellowness-blueness
        let b = (rA + gA - 2.0 * bA) / 9.0

        // auxiliary components
        let u = (20.0 * rA + 20.0 * gA + 21.0 * bA) / 20.0
        let p2 = (40.0 * rA + 20.0 * gA + bA) / 20.0

        // hue
        let atan2 = atan2(b, a)
        let atanDegrees = atan2 * 180.0 / Double.pi
        let hue = atanDegrees < 0 ? atanDegrees + 360.0 : atanDegrees >= 360 ? atanDegrees - 360 : atanDegrees
        let hueRadians = hue * Double.pi / 180.0
        assert(hue >= 0 && hue < 360, "hue was really $hue")

        // achromatic response to color
        let ac = p2 * viewingConditions.nbb

        // CAM16 lightness and brightness
        let j = 100.0 * pow(ac / viewingConditions.aw, viewingConditions.c * viewingConditions.z)
        let q = (4.0 / viewingConditions.c) * sqrt(j / 100.0) * (viewingConditions.aw + 4.0) * (viewingConditions.fLRoot)

        let huePrime = (hue < 20.14) ? hue + 360 : hue
        let eHue = (1.0 / 4.0) * (cos(huePrime * Double.pi / 180.0 + 2.0) + 3.8)
        let p1 = 50000.0 / 13.0 * eHue * viewingConditions.nC * viewingConditions.ncb
        let t = p1 * sqrt(a * a + b * b) / (u + 0.305)
        let alpha = pow(t, 0.9) * pow( 1.64 - pow(0.29, viewingConditions.backgroundYTowhitePointY), 0.73)
        // CAM16 chroma, colorfulness, chroma
        let c = alpha * sqrt(j / 100.0)
        let m = c * viewingConditions.fLRoot
        let s = 50.0 * sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))

        // CAM16-UCS components
        let jstar = (1.0 + 100.0 * 0.007) * j / (1.0 + 0.007 * j)
        let mstar = log(1.0 + 0.0228 * m) / 0.0228
        let astar = mstar * cos(hueRadians)
        let bstar = mstar * sin(hueRadians)
        self.init(hue: hue, chroma: c, j: j, q: q, m: m, s: s, jstar: jstar, astar: astar, bstar: bstar)
    }
}
