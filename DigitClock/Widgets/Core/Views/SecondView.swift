//
//  SecondView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/26.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct SecondView: View {
    let time: Time
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Text(time.date, style: .timer)
                .multilineTextAlignment(.trailing)
                .background(Color.gray)
                .monospacedDigit()

            GeometryReader { proxy in
                backgroundColor
                    .width(proxy.size.width / 3 * 1.25)
            }
        }
//        .fixedSize()
    }
}

#Preview {
    ScrollView {
        let fontSizes = (10 ... 20).map { $0 * 10 }
        VStack {
            ForEach(fontSizes, id: \.self) {
                SecondView(time: Time(), backgroundColor: Color.gray)
                    .font(.system(size: CGFloat($0), design: .rounded), weight: .ultraLight)
            }
        }
    }
}
