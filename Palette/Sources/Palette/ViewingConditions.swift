//
//  ViewingConditions.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

// swiftlint:disable all
struct ViewingConditions {
    static let standard = sRgb
    static let sRgb = ViewingConditions()

    let whitePoint: [Double]
    let adaptingLuminance: Double
    let backgroundLstar: Double
    let surround: Double
    let discountingIlluminant: Bool

    let backgroundYTowhitePointY: Double
    let aw: Double
    let nbb: Double
    let ncb: Double
    let c: Double
    let nC: Double
    let drgbInverse: [Double]
    let rgbD: [Double]
    let fl: Double
    let fLRoot: Double
    let z: Double

    init(whitePoint: [Double], adaptingLuminance: Double, backgroundLstar: Double, surround: Double, discountingIlluminant: Bool, backgroundYTowhitePointY: Double, aw: Double, nbb: Double, ncb: Double, c: Double, nC: Double, drgbInverse: [Double], rgbD: [Double], fl: Double, fLRoot: Double, z: Double) {
        self.whitePoint = whitePoint
        self.adaptingLuminance = adaptingLuminance
        self.backgroundLstar = backgroundLstar
        self.surround = surround
        self.discountingIlluminant = discountingIlluminant
        self.backgroundYTowhitePointY = backgroundYTowhitePointY
        self.aw = aw
        self.nbb = nbb
        self.ncb = ncb
        self.c = c
        self.nC = nC
        self.drgbInverse = drgbInverse
        self.rgbD = rgbD
        self.fl = fl
        self.fLRoot = fLRoot
        self.z = z
    }

    init(
        whitePoint: [Double]? = nil,
        adaptingLuminance: Double = -1.0,
        backgroundLstar: Double = 50.0,
        surround: Double = 2.0,
        discountingIlluminant: Bool = false
    ) {
        let whitePoint = whitePoint ?? ColorUtils.whitePointD65

        let adaptingLuminance = (adaptingLuminance > 0.0)
        ? adaptingLuminance
        : (200.0 / Double.pi * ColorUtils.y(from: 50.0) / 100.0)
        let backgroundLstar = max(30.0, backgroundLstar)
        // Transform test illuminant white in XYZ to 'cone'/'rgb' responses
        let xyz = whitePoint
        let rW = xyz[0] * 0.401288 + xyz[1] * 0.650173 + xyz[2] * -0.051461
        let gW = xyz[0] * -0.250268 + xyz[1] * 1.204414 + xyz[2] * 0.045854
        let bW = xyz[0] * -0.002079 + xyz[1] * 0.048952 + xyz[2] * 0.953127

        // Scale input surround, domain (0, 2), to CAM16 surround, domain (0.8, 1.0)
        assert(surround >= 0.0 && surround <= 2.0)
        let f = 0.8 + (surround / 10.0)
        // "Exponential non-linearity"
        let c = (f >= 0.9)
        ? MathUtils.lerp(start: 0.59, stop: 0.69, amount: ((f - 0.9) * 10.0))
        : MathUtils.lerp(start: 0.525, stop: 0.59, amount: ((f - 0.8) * 10.0))
        // Calculate degree of adaptation to illuminant
        var d = discountingIlluminant ? 1.0 : f * (1.0 - ((1.0 / 3.6) * exp((-adaptingLuminance - 42.0) / 92.0)))
        // Per Li et al, if D is greater than 1 or less than 0, set it to 1 or 0.
        d = (d > 1.0) ? 1.0 : (d < 0.0) ? 0.0 : d
        // chromatic induction factor
        let nc = f

        // Cone responses to the whitePoint, r/g/b/W, adjusted for discounting.
        //
        // Why use 100.0 instead of the white point's relative luminance?
        //
        // Some papers and implementations, for both CAM02 and CAM16, use the Y
        // value of the reference white instead of 100. Fairchild's Color Appearance
        // Models (3rd edition) notes that this is in error: it was included in the
        // CIE 2004a report on CIECAM02, but, later parts of the conversion process
        // account for scaling of appearance relative to the white point relative
        // luminance. This part should simply use 100 as luminance.
        let rgbD = [
            d * (100.0 / rW) + 1.0 - d,
            d * (100.0 / gW) + 1.0 - d,
            d * (100.0 / bW) + 1.0 - d
        ]

        // Factor used in calculating meaningful factors
        let k = 1.0 / (5.0 * adaptingLuminance + 1.0)
        let k4 = k * k * k * k
        let k4F = 1.0 - k4

        // Luminance-level adaptation factor
        let fl = (k4 * adaptingLuminance) +
        (0.1 * k4F * k4F * pow(5.0 * adaptingLuminance, 1.0 / 3.0))
        // Intermediate factor, ratio of background relative luminance to white relative luminance
        let n = ColorUtils.y(from: backgroundLstar) / whitePoint[1]

        // Base exponential nonlinearity
        // note Schlomer 2018 has a typo and uses 1.58, the correct factor is 1.48
        let z = 1.48 + sqrt(n)

        // Luminance-level induction factors
        let nbb = 0.725 / pow(n, 0.2)
        let ncb = nbb

        // Discounted cone responses to the white point, adjusted for post-saturationtic
        // adaptation perceptual nonlinearities.
        let rgbAFactors = [
            pow(fl * rgbD[0] * rW / 100.0, 0.42),
            pow(fl * rgbD[1] * gW / 100.0, 0.42),
            pow(fl * rgbD[2] * bW / 100.0, 0.42)
        ]

        let rgbA = [
            (400.0 * rgbAFactors[0]) / (rgbAFactors[0] + 27.13),
            (400.0 * rgbAFactors[1]) / (rgbAFactors[1] + 27.13),
            (400.0 * rgbAFactors[2]) / (rgbAFactors[2] + 27.13)
        ]

        let aw = (40.0 * rgbA[0] + 20.0 * rgbA[1] + rgbA[2]) / 20.0 * nbb

        self.init(
            whitePoint: whitePoint,
            adaptingLuminance: adaptingLuminance,
            backgroundLstar: backgroundLstar,
            surround: surround,
            discountingIlluminant: discountingIlluminant,
            backgroundYTowhitePointY: n,
            aw: aw,
            nbb: nbb,
            ncb: ncb,
            c: c,
            nC: nc,
            drgbInverse: [0.0, 0.0, 0.0],
            rgbD: rgbD,
            fl: fl,
            fLRoot: pow(fl, 0.25),
            z: z
        )
    }
}

// swiftlint:enable all
