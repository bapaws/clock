//
//  QuickTimingItemView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/7/10.
//

import HoursShare
import SwiftUI

struct QuickLargeTimingItemView: View {
    let entity: TimingEntity
    let dimensions: CGFloat
    var body: some View {
        let label = VStack {
            Text(timerInterval: entity.timerInterval, countsDown: false)
                .contentTransition(.numericText(countsDown: false))
                .font(.system(.caption, design: .rounded, weight: .regular))
                .foregroundStyle(entity.primary)
                .frame(width: dimensions, height: dimensions, alignment: .center)
                .widgetAccentable()
                .background(entity.primaryContainer)
                .modify(if: \.widgetRenderingMode, equals: .accented) {
                    $0.luminanceToAlpha()
                }
                .cornerRadius(16)

            Text(entity.title)
                .lineLimit(2)
                .minimumScaleFactor(0.4)
                .font(.caption2)
                .foregroundStyle(entity.primary)
        }

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
