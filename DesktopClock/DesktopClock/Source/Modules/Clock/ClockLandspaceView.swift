//
//  ClockLandspaceView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct ClockLandspaceView: View {
    @EnvironmentObject var clock: ClockManager

    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    var colonWidth: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min((proxy.size.width - colonWidth - spacing * 2) / 2, proxy.size.height)
            let secondWidth = floor(digitWidth / 3.5)
            ZStack(alignment: .bottomTrailing) {
                HStack(alignment: .center, spacing: spacing) {
                    NeumorphicDigit(tens: clock.hourTens, ones: clock.hourOnes)
                        .frame(width: digitWidth, height: digitWidth)
                    NeumorphicLandspaceColon(outer: clock.time.seconds % 2 == 0)
                        .frame(width: colonWidth, height: proxy.size.height)
                    NeumorphicDigit(tens: clock.time.minuteTens, ones: clock.time.minuteOnes)
                        .frame(width: digitWidth, height: digitWidth)
                }

                if clock.timeFormat == .h12 {
                    Text(clock.time.meridiem.rawValue)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth / 4), design: .rounded), weight: .bold)
                        .offset(x: -proxy.size.width + secondWidth, y: -(proxy.size.height - digitWidth) / 2 - digitWidth + secondWidth)
                }

                if clock.secondStyle != .none {
                    NeumorphicDigit(tens: clock.time.secondTens, ones: clock.time.secondOnes)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth / 2), design: .rounded), weight: .bold)
                        .offset(x: 0, y: -(proxy.size.height - digitWidth) / 2)
                }
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .background(UIManager.shared.color.background)
    }
}

#Preview {
    ClockLandspaceView()
        .environmentObject(ClockManager.shared)
}
