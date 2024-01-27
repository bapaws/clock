//
//  PomodoroWidget.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import SwiftUIX

struct PomodoroWidget: View {
    let time: Time

    var padding: CGFloat = 16
    let spacing: CGFloat = 32
    let digitWidth: CGFloat = 96

    var body: some View {
        HStack(spacing: spacing) {
            DigitView(tens: time.minuteTens, ones: time.minuteOnes)
            DigitView(tens: time.secondTens, ones: time.secondOnes)
        }
        .font(.system(size: 75, design: .rounded), weight: .ultraLight)
        .minimumScaleFactor(0.2)
    }
}

#Preview {
    PomodoroWidget(time: Time())
}
