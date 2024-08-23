//
//  QuickEventItemView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/7/10.
//

import HoursShare
import SwiftUI

struct QuickEventItemView: View {
    var event: EventEntity
    var padding: CGFloat
    var dimension: CGFloat

    var body: some View {
        let label = VStack {
            Spacer()
            if let emoji = event.emoji, !emoji.isEmpty {
                Text(emoji)
                Spacer()
            }
            Text(event.name)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .font(.subheadline)
                .foregroundStyle(event.primary)
            Spacer()
        }
        .padding(padding)
        .frame(width: dimension, height: dimension, alignment: .center)
        .background(event.primaryContainer)
        .cornerRadius(16)

        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: QuickStartTimerAppIntent(eventID: event.id)) {
                label
            }
            .buttonStyle(.borderless)
        } else {
            label
        }
    }
}

#Preview {
    QuickEventItemView(
        event: .random(), padding: 8, dimension: 90
    )
}
