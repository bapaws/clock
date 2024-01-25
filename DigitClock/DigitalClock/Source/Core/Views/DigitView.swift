//
//  DigitView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/20.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct DigitView: View {
    let tens: Int
    let ones: Int
    let color: Colors

    var spacing: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let digitWidth = proxy.size.width / 2
            HStack(spacing: spacing) {
                Spacer()
                Text("\(tens)")
//                    .minimumScaleFactor(0.1)
                    .frame(width: digitWidth, height: proxy.size.height, alignment: .trailing)
                Text("\(ones)")
//                    .minimumScaleFactor(0.1)
                    .frame(width: digitWidth, height: proxy.size.height, alignment: .center)
                Spacer()
            }
            .frame(proxy.size)
        }
    }
}

#Preview {
    DigitView(tens: 2, ones: 5, color: ColorType.classic.colors)
}
