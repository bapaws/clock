//
//  QuickEventItemView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/7/10.
//

import HoursShare
import SwiftUI

struct QuickEventItemView: View {
    var event: QuickEventEntity
    var padding: CGFloat
    var dimension: CGFloat

    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    var body: some View {
        VStack {
            Spacer()
            if let emoji = event.emoji, !emoji.isEmpty {
                Text(emoji)
                Spacer()
            }
            Text(event.name)
                .lineLimit(2)
                .minimumScaleFactor(0.4)
                .font(.caption2)
                .foregroundStyle(event.primary)
            Spacer()
        }
        .padding(padding)
        .frame(width: dimension, height: dimension, alignment: .center)
        .widgetAccentable()
        .background(event.primaryContainer)
        .modify(if: \.widgetRenderingMode, equals: .accented) {
            $0.luminanceToAlpha()
        }
        .cornerRadius(16)
    }
}

// #Preview {
//    QuickEventItemView(
//        event: .random(), padding: 8, dimension: 90
//    )
// }
