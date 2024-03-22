//
//  TonalPalette.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

struct TonalPalette {
    /// Commonly-used tone values.
    static let commonTones = [
        0,
        10,
        20,
        30,
        40,
        50,
        60,
        70,
        80,
        90,
        95,
        99,
        100
    ]

    let hue: Double
    let chroma: Double

    /// Returns the ARGB representation of an HCT color.
    ///
    /// If the class was instantiated from [_hue] and [chroma], will return the
    /// color with corresponding [tone].
    /// If the class was instantiated from a fixed-size list of color ints, [tone]
    /// must be in [commonTones].
    func argb(from tone: Int) -> Int {
        let chroma = (tone >= 90) ? min(chroma, 40.0) : chroma
        return HCT(hue: hue, chroma: chroma, tone: Double(tone)).argb
    }
}
