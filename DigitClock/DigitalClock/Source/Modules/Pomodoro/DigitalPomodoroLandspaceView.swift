//
//  DigitalPomodoroLandspaceView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct DigitalPomodoroLandspaceView: View {
    let time: Time
    let color: Colors
    let spacing: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min((proxy.size.width - spacing * (time.hour != 0 ? 2 : 0)) / 2, proxy.size.height)
            let digitHeight = ceil(digitWidth * 0.8)
            HStack(spacing: spacing) {
                if time.hour != 0 {
                    Text("\(time.hourTens)\(time.hourOnes)")
                        .frame(width: digitWidth, height: digitHeight)
                }
                Text("\(time.minuteTens)\(time.minuteOnes)")
                    .frame(width: digitWidth, height: digitHeight)
                Text("\(time.secondTens)\(time.secondOnes)")
                    .frame(width: digitWidth, height: digitHeight)
            }
            .monospacedDigit()
            .font(.system(size: digitHeight, design: .rounded), weight: .ultraLight)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DigitalPomodoroLandspaceView(time: PomodoroManager.shared.time, color: ColorType.classic.colors)
}
