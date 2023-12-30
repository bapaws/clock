//
//  PomodoroLandspaceView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import SwiftUI

struct PomodoroLandspaceView: View {
    let time: Time
    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    let colonWidth: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min((proxy.size.width - colonWidth - spacing * 2) / 2, proxy.size.height)
            HStack(alignment: .center, spacing: spacing) {
                Spacer()
                NeumorphicDigit(tens: time.minuteTens, ones: time.minuteOnes)
                    .frame(width: digitWidth, height: digitWidth)
                NeumorphicLandspaceColon(outer: time.seconds % 2 == 0)
                    .frame(width: colonWidth, height: proxy.size.height)
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
    PomodoroLandspaceView(time: PomodoroManager.shared.time)
}
