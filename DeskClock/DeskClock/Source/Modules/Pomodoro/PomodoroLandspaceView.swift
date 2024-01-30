//
//  PomodoroLandspaceView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct PomodoroLandspaceView: View {
    let time: Time
    let color: Colors
    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    let colonWidth: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min((proxy.size.width - colonWidth - spacing * 2) / 2, proxy.size.height)
            let hourWidth = floor(digitWidth / 3.5)
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center, spacing: spacing) {
                    NeumorphicDigit(tens: time.minuteTens, ones: time.minuteOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)
                    NeumorphicLandspaceColon(outer: time.seconds % 2 == 0, color: color)
                        .frame(width: colonWidth, height: proxy.size.height)
                    NeumorphicDigit(tens: time.secondTens, ones: time.secondOnes, color: color)
                        .frame(width: digitWidth, height: digitWidth)
                }

                if time.hour != 0 {
                    let offsetX = (proxy.size.width - digitWidth * 2 - spacing * 2 - colonWidth) / 2
                    let offsetY = (proxy.size.height - digitWidth) / 2
                    NeumorphicDigit(tens: time.hourTens, ones: time.hourOnes, color: color)
                        .frame(width: hourWidth, height: hourWidth)
                        .font(.system(size: floor(hourWidth / 2), design: .rounded), weight: .bold)
                        .offset(x: offsetX, y: offsetY)
                }
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    PomodoroLandspaceView(time: PomodoroManager.shared.time, color: ColorType.classic.colors)
}
