//
//  DigitalTimerLandspaceView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct DigitalTimerLandspaceView: View {
    let time: Time
    let color: Colors
    let spacing: CGFloat = 16

    @EnvironmentObject var timer: TimerManager

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(ceil((proxy.size.width - spacing * (1 + timer.hourStyle.digitCount)) / (2 + timer.hourStyle.heightMultiple)), proxy.size.height)
            HStack(alignment: .center, spacing: spacing) {
                if time.hour != 0 || timer.hourStyle != .none {
                    Text("\(time.hourTens)\(time.hourOnes)")
                        .frame(width: digitWidth, height: digitWidth)
                }
                Text("\(time.minuteTens)\(time.minuteOnes)")
                    .frame(width: digitWidth, height: digitWidth)
                Text("\(time.secondTens)\(time.secondOnes)")
                    .frame(width: digitWidth, height: digitWidth)
            }
            .monospacedDigit()
            .font(.system(size: digitWidth * 0.8, design: .rounded), weight: .ultraLight)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DigitalTimerLandspaceView(time: TimerManager.shared.time, color: ColorType.classic.colors)
}
