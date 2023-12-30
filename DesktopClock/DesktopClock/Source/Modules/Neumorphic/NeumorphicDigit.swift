//
//  NeumorphicDigit.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/24.
//

import SwiftUI
import SwiftUIX

struct NeumorphicDigit: View {
    let tens: Int
    let ones: Int

    var fontSize: CGFloat = 120
    var spacing: CGFloat = 16
    let cornerRadius: CGFloat = 25.0

    @EnvironmentObject var ui: UIManager

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
            .softInnerShadow(RoundedRectangle(cornerRadius: cornerRadius), darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow, spread: 0.1, radius: 5)
        }
    }
}

#Preview {
    NeumorphicDigit(tens: 2, ones: 5)
        .environmentObject(UIManager.shared)
}
