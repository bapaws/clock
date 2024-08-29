//
//  QuickTimingItemView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/7/10.
//

import HoursShare
import SwiftUI

struct QuickTimingItemView: View {
    let entity: TimingEntity
    let dimensions: CGFloat
    var body: some View {
        let label = VStack {
            Spacer()

            HStack(spacing: 0) {
                if let emoji = entity.emoji, !emoji.isEmpty {
                    Text(emoji)
                        .font(.caption2)
                }
                Text(entity.name)
                    .font(.caption)
            }
            .foregroundStyle(entity.primary)

            Spacer()

            Text(timerInterval: entity.timerInterval, countsDown: false)
                .contentTransition(.numericText(countsDown: false))
                .font(.system(.caption, design: .rounded, weight: .regular))
                .foregroundStyle(entity.primary)

            Spacer()
        }
        .padding(.extraSmall)
        .frame(width: dimensions, height: dimensions)
        .background(entity.primaryContainer)
        .cornerRadius(16)

        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: QuickStopTimerAppIntent(eventID: entity.id)) {
                label
            }
            .background(.clear)
            .buttonStyle(BorderlessButtonStyle())
        } else {
            label
        }
    }
}

#Preview {
    QuickTimingItemView(
        entity: TimingEntity.random(), dimensions: 90
    )
}
