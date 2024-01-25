//
//  ClockLandspaceView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct ClockLandspaceView: View {
    @EnvironmentObject var clock: ClockManager
    let color: Colors

    let spacing: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(ceil((proxy.size.width - spacing * (1 + clock.secondStyle.digitCount)) / (2 + clock.secondStyle.heightMultiple)), proxy.size.height)
            let secondWidth = floor(digitWidth * clock.secondStyle.heightMultiple)
            ZStack {
                HStack(spacing: spacing) {
                    DigitView(tens: clock.hourTens, ones: clock.hourOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)

                    DigitView(tens: clock.time.minuteTens, ones: clock.time.minuteOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)
                    if clock.secondStyle == .big {
                        DigitView(tens: clock.time.secondTens, ones: clock.time.secondOnes, color: color)
                            .frame(width: secondWidth, height: secondWidth)
                    }
                }
                if clock.secondStyle == .small {
                    DigitView(tens: clock.time.secondTens, ones: clock.time.secondOnes, color: color)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth * 0.5), design: .rounded), weight: .ultraLight)
                        .offset(y: proxy.size.height / 2)
                }
            }
            .font(.system(size: digitWidth * 0.8, design: .rounded), weight: .ultraLight)
            .frame(proxy.size)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ClockLandspaceView(color: ColorType.classic.colors)
        .environmentObject(ClockManager.shared)
}
