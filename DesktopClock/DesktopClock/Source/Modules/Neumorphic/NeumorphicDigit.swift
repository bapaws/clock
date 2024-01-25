//
//  NeumorphicDigit.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import ClockShare
import DesktopClockShare
import SwiftUI
import SwiftUIX

struct NeumorphicDigit: View {
    let tens: Int
    let ones: Int
    let color: Colors

    var fontSize: CGFloat = 120
    var spacing: CGFloat = 16
    var cornerRadius: CGFloat = 25.0
    var spread: CGFloat = 0.1
    var radius: CGFloat = 10

    var body: some View {
        GeometryReader { proxy in
            let spacing = proxy.size.width / 10
            let digitWidth = (proxy.size.width - spacing * 2) / 2
            HStack(spacing: 0) {
                Color.clear.frame(width: spacing, height: 1)
                Spacer()
                Text("\(tens)")
                    .minimumScaleFactor(0.1)
                    .frame(width: digitWidth, height: proxy.size.height)
                Text("\(ones)")
                    .minimumScaleFactor(0.1)
                    .frame(width: digitWidth, height: proxy.size.height)
                Spacer()
                Color.clear.frame(width: spacing, height: 1)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .softInnerShadow(RoundedRectangle(cornerRadius: cornerRadius), darkShadow: color.darkShadow, lightShadow: color.lightShadow, spread: spread, radius: radius)
        }
    }
}

#Preview {
    NeumorphicDigit(tens: 2, ones: 5, color: ColorType.classic.colors)
}
