//
//  StatisticsDailyBarChartView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/13.
//

import HoursShare
import SwiftUI

struct StatisticsDailyRatioView: View {
    let icon: String?
    let emoji: String?
    let title: String
    let milliseconds: Int
    let totalMilliseconds: Int
    let foregroundColor: Color

    init(icon: String? = nil, emoji: String? = nil, title: String, milliseconds: Int, totalMilliseconds: Int, foregroundColor: Color) {
        self.icon = icon
        self.emoji = emoji
        self.title = title
        self.milliseconds = milliseconds
        self.totalMilliseconds = totalMilliseconds
        self.foregroundColor = foregroundColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                if let emoji = emoji {
                    Text(emoji)
                }
                Text(title)
                Spacer()
                Text(milliseconds.shortTimeLengthText)
            }
            .font(.footnote)

            GeometryReader { proxy in
                HStack(spacing: 0) {
                    let ratio = totalMilliseconds > 0 ? CGFloat(milliseconds) / CGFloat(totalMilliseconds) : 0
                    let capsuleWidth = proxy.size.width - 48
                    Capsule()
                        .fill(ui.background)
                        .frame(width: capsuleWidth, height: 8)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(foregroundColor)
                                .frame(width: (capsuleWidth - 8) * ratio + 8, height: 8)
                        }
                    Text(String(format: "%.1f%%", ratio * 100))
                        .font(.caption)
                        .foregroundStyle(ui.secondaryLabel)
                        .frame(width: 48, alignment: .trailing)
                }
            }
        }
        .height(32)
    }
}

#Preview {
    StatisticsDailyRatioView(title: "Sports", milliseconds: 100, totalMilliseconds: 1000, foregroundColor: UIManager.shared.primary)
}
