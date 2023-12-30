//
//  PomodoroPortraitView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct PomodoroPortraitView: View {
    let time: Time
    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    let colonHeight: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(proxy.size.width, (proxy.size.height - colonHeight - spacing * 2) / 2)
            VStack(alignment: .center, spacing: spacing) {
                Spacer()
                NeumorphicDigit(tens: time.minuteTens, ones: time.minuteOnes)
                    .frame(width: digitWidth, height: digitWidth)
                NeumorphicPortraitColon(outer: time.seconds % 2 == 0)
                    .frame(width: proxy.size.width, height: colonHeight)
                NeumorphicDigit(tens: time.secondTens, ones: time.secondOnes)
                    .frame(width: digitWidth, height: digitWidth)
                Spacer()
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    PomodoroPortraitView(time: PomodoroManager.shared.time)
}
