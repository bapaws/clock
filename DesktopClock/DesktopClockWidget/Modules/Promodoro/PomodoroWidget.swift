//
//  PomodoroWidget.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct PomodoroWidget: View {
    let time: Time
    let colorType: ColorType
    let colors: Colors

    var padding: CGFloat = 16
    var spacing: CGFloat = 4
    var colonWidth: CGFloat = 16
    var digitWidth: CGFloat = 96

    var body: some View {
        HStack(spacing: spacing) {
            DigitView(tens: time.minuteTens, ones: time.minuteOnes, colorType: colorType)
                .frame(width: digitWidth, height: digitWidth)
            ColonView(colorType: colorType)
                .frame(width: colonWidth, height: digitWidth)
            DigitView(tens: time.secondTens, ones: time.secondOnes, colorType: colorType)
                .frame(width: digitWidth, height: digitWidth)
        }
        .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
        .minimumScaleFactor(0.2)
        .foregroundColor(colors.primary)
//        .frame(.greedy)
    }
}
