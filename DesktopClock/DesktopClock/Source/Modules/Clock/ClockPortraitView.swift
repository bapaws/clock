//
//  ClockPortraitView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import SwiftUI

struct ClockPortraitView: View {
    @EnvironmentObject var clock: ClockManager

    let padding: CGFloat = 32
    let spacing: CGFloat = 16
    let colonHeight: CGFloat = 32

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = min(proxy.size.width, (proxy.size.height - colonHeight - spacing * 2) / 2)
            let secondWidth = floor(digitWidth / 3.5)
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .center, spacing: spacing) {
                    NeumorphicDigit(tens: clock.hourTens, ones: clock.hourOnes)
                        .frame(width: digitWidth, height: digitWidth)
                    NeumorphicPortraitColon(outer: clock.time.seconds % 2 == 0)
                        .frame(width: digitWidth, height: colonHeight)
                    NeumorphicDigit(tens: clock.time.minuteTens, ones: clock.time.minuteOnes)
                        .frame(width: digitWidth, height: digitWidth)
                }

                if clock.secondStyle != .none {
                    NeumorphicDigit(tens: clock.time.secondTens, ones: clock.time.secondOnes)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth / 2), design: .rounded), weight: .bold)
                        .offset(x: 0, y: -(proxy.size.height - digitWidth * 2 - colonHeight - spacing * 2) / 2)
                }

                if clock.timeFormat == .h12 {
                    Text(clock.time.meridiem.rawValue)
                        .frame(width: secondWidth, height: secondWidth)
                        .font(.system(size: floor(secondWidth / 4), design: .rounded), weight: .bold)
                        .offset(x: -digitWidth + secondWidth, y: -proxy.size.height + secondWidth)
                }
            }
            .font(.system(size: digitWidth * 0.6, design: .rounded), weight: .bold)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .background(UIManager.shared.color.background)
    }
}

#Preview {
    ClockPortraitView()
        .environmentObject(ClockManager.shared)
}
