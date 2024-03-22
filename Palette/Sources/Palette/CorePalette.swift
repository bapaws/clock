//
//  CorePalette.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/10/3.
//

import Foundation

struct CorePalette {
    let primary: TonalPalette
    let secondary: TonalPalette
    let tertiary: TonalPalette
    let neutral: TonalPalette
    let neutralVariant: TonalPalette
    let error: TonalPalette = TonalPalette(hue: 25, chroma: 84)

    init(primary: TonalPalette, secondary: TonalPalette, tertiary: TonalPalette, neutral: TonalPalette, neutralVariant: TonalPalette) {
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.neutral = neutral
        self.neutralVariant = neutralVariant
    }

    init(argb: Int) {
        let cam = Cam16(argb: argb)
        self.init(hue: cam.hue, chroma: cam.chroma)
    }

    init(hue: Double, chroma: Double) {
        self.init(
            primary: TonalPalette(hue: hue, chroma: max(48, chroma)),
            secondary: TonalPalette(hue: hue, chroma: 16),
            tertiary: TonalPalette(hue: hue + 60, chroma: 24),
            neutral: TonalPalette(hue: hue, chroma: 4),
            neutralVariant: TonalPalette(hue: hue, chroma: 8)
        )
    }
}
