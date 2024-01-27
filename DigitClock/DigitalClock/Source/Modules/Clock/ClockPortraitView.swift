//
//  ClockPortraitView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct ClockPortraitView: View {
    @EnvironmentObject var clock: ClockManager
    let color: Colors

    let spacing: CGFloat = 16

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(proxy.size.width, ceil((proxy.size.height - spacing * (1 + clock.secondStyle.digitCount)) / (2 + clock.secondStyle.heightMultiple)))
            let digitHeight = ceil(digitWidth * 0.8)
            let secondWidth = floor(digitWidth * clock.secondStyle.heightMultiple)
            VStack(alignment: .center, spacing: spacing) {
                Spacer()
                DigitView(tens: clock.hourTens, ones: clock.hourOnes)
                    .frame(width: digitWidth, height: digitHeight)
                DigitView(tens: clock.time.minuteTens, ones: clock.time.minuteOnes)
                    .frame(width: digitWidth, height: digitHeight)
                if clock.secondStyle == .big {
                    DigitView(tens: clock.time.secondTens, ones: clock.time.secondOnes)
                        .frame(width: digitWidth, height: digitHeight)
                } else if clock.secondStyle == .small {
                    DigitView(tens: clock.time.secondTens, ones: clock.time.secondOnes)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(digitWidth * 0.25), design: .rounded), weight: .ultraLight)
                }
                Spacer()
            }
            .font(.system(size: digitHeight, design: .rounded), weight: .ultraLight)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ClockPortraitView(color: ColorType.classic.colors)
        .environmentObject(ClockManager.shared)
}
