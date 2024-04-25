//
//  DigitalClockLandspaceView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct DigitalClockLandspaceView: View {
    @EnvironmentObject var clock: ClockManager
    let color: Colors

    let spacing: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(ceil((proxy.size.width - spacing * (1 + clock.secondStyle.digitCount)) / (2 + clock.secondStyle.heightMultiple)), proxy.size.height)
            let secondWidth = floor(digitWidth * clock.secondStyle.heightMultiple)
            ZStack {
                HStack(spacing: spacing) {
                    Text("\(clock.hourTens)\(clock.hourOnes)")
                        .frame(width: digitWidth, height: digitWidth)

                    Text("\(clock.time.minuteTens)\(clock.time.minuteOnes)")
                        .frame(width: digitWidth, height: digitWidth)
                    if clock.secondStyle == .big {
                        Text("\(clock.time.secondTens)\(clock.time.secondOnes)")
                            .frame(width: secondWidth, height: secondWidth)
                    }
                }
                if clock.secondStyle == .small {
                    Text("\(clock.time.secondTens)\(clock.time.secondOnes)")
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth * 0.5), design: .rounded), weight: .ultraLight)
                        .offset(y: proxy.size.height / 2)
                }
            }
            .monospacedDigit()
            .font(.system(size: digitWidth * 0.8, design: .rounded), weight: .ultraLight)
            .frame(proxy.size)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DigitalClockLandspaceView(color: ColorType.classic.colors)
        .environmentObject(ClockManager.shared)
}
