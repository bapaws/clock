//
//  TimingEntityView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/7/10.
//

import HoursShare
import SwiftUI

struct TimingEntityView: View {
    let entity: TimingEntity
    let dimensions: CGFloat
    var body: some View {
        let label = VStack {
            Spacer()

            HStack(spacing: 0) {
                if let emoji = entity.emoji, !emoji.isEmpty {
                    Text(emoji)
                        .font(.footnote)
                }
                Text(entity.name)
                    .font(.subheadline)
            }
            .foregroundStyle(entity.primary)

            Spacer()

            HStack(spacing: 0) {
                Image(systemName: "stop.fill")
                    .font(.system(.callout, design: .rounded))

                Text(timerInterval: entity.timerInterval, countsDown: false)
                    .contentTransition(.numericText(countsDown: false))
                    .font(.system(.callout, design: .rounded, weight: .bold))
                    .minimumScaleFactor(0.5)
                    .monospacedDigit()
            }
            .foregroundStyle(entity.primary)

            Spacer()
        }
        .padding(.small)
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
    TimingEntityView(
        entity: TimingEntity.random(), dimensions: 90
    )
}
