//
//  DigitView.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/9.
//

import ClockShare
import SwiftUI
import SwiftUIX

struct DigitView: View {
    let tens: Int
    let ones: Int
    let colorType: ColorType

    var spacing: CGFloat = 2

    var body: some View {
        ZStack {
            Image("\(colorType.rawValue)Inner")
                .resizable()
                .scaledToFill()
                .frame(.greedy)
            HStack(spacing: spacing) {
                Text("\(tens)")
                Text("\(ones)")
            }
            .frame(.greedy)
        }
        .frame(.greedy)
    }
}

#Preview {
    DigitView(tens: 2, ones: 5, colorType: .classic)
}
