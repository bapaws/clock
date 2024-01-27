//
//  PomodoroPortraitView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct PomodoroPortraitView: View {
    let time: Time
    let color: Colors
    let spacing: CGFloat = 16

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(proxy.size.width, (proxy.size.height - spacing * (time.hour != 0 ? 2 : 0)) / 2)
            let digitHeight = ceil(digitWidth * 0.8)
            VStack(alignment: .center, spacing: spacing) {
                Spacer()
                if time.hour != 0 {
                    DigitView(tens: time.hourTens, ones: time.hourOnes)
                        .frame(width: digitWidth, height: digitHeight)
                }
                DigitView(tens: time.minuteTens, ones: time.minuteOnes)
                    .frame(width: digitWidth, height: digitHeight)
                DigitView(tens: time.secondTens, ones: time.secondOnes)
                    .frame(width: digitWidth, height: digitHeight)
                Spacer()
            }
            .font(.system(size: digitHeight, design: .rounded), weight: .ultraLight)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    PomodoroPortraitView(time: PomodoroManager.shared.time, color: ColorType.classic.colors)
}
