//
//  TimerPortraitView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct TimerPortraitView: View {
    let time: Time
    let color: Colors
    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    let colonHeight: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(proxy.size.width, (proxy.size.height - colonHeight - spacing * 2) / 2)
            let secondWidth = floor(digitWidth / 3.5)
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .center, spacing: spacing) {
                    NeumorphicDigit(tens: time.hourTens, ones: time.hourOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)
                    NeumorphicPortraitColon(outer: time.seconds % 2 == 0, color: color)
                        .frame(width: digitWidth, height: colonHeight)
                    NeumorphicDigit(tens: time.minuteTens, ones: time.minuteOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)
                }

                NeumorphicDigit(tens: time.secondTens, ones: time.secondOnes, color: color)
                    .frame(width: secondWidth, height: secondWidth)
                    .font(.system(size: floor(secondWidth / 2), design: .rounded), weight: .bold)
                    .offset(x: 0, y: -(proxy.size.height - digitWidth * 2 - colonHeight - spacing * 2) / 2)
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    TimerPortraitView(time: TimerManager.shared.time, color: ColorType.classic.colors)
}
