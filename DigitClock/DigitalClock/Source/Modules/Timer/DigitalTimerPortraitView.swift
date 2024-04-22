//
//  DigitalTimerPortraitView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct DigitalTimerPortraitView: View {
    let time: Time
    let color: Colors
    let spacing: CGFloat = 16

    @EnvironmentObject var timer: TimerManager

    var body: some View {
        GeometryReader { proxy in
            let digitCount: CGFloat = time.hour != 0 || timer.hourStyle != .none ? 3 : 2
            let digitWidth = min(proxy.size.width, floor((proxy.size.height - spacing * (digitCount - 1)) / digitCount))
            let digitHeight = ceil(digitWidth * 0.8)
            VStack(alignment: .center, spacing: spacing) {
                Spacer()
                if time.hour != 0 || timer.hourStyle != .none {
                    Text("\(time.hourTens)\(time.hourOnes)")
                        .frame(width: digitWidth, height: digitHeight)
                }
                Text("\(time.minuteTens)\(time.minuteOnes)")
                    .frame(width: digitWidth, height: digitHeight)
                Text("\(time.secondTens)\(time.secondOnes)")
                    .frame(width: digitWidth, height: digitHeight)
                Spacer()
            }
            .monospacedDigit()
            .font(.system(size: digitWidth * 0.8, design: .rounded), weight: .ultraLight)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DigitalTimerPortraitView(time: TimerManager.shared.time, color: ColorType.classic.colors)
}
