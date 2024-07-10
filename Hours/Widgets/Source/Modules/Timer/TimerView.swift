//
//  TimerView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/5/22.
//

import ClockShare
import HoursShare
import SwiftUI
import WidgetKit

@available(iOSApplicationExtension 16.1, *)
struct TimerView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let entities: [TimingEntity]

    private let space: CGFloat = 8

    init(context: ActivityViewContext<TimingEntityActivityAttributes>) {
        self.entities = context.state
    }

    init(entities: [TimingEntity]) {
        self.entities = entities
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(R.string.localizable.tracking("\(entities.count)"))
                    .font(.headline)

                Spacer()
                if let icon = R.image.icon() {
                    Image(uiImage: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(4)
                }
            }

            GeometryReader { proxy in
                let dimensions = (proxy.size.width - space * 3) / 4
                HStack(spacing: space) {
                    ForEach(entities) { entity in
                        TimingEntityView(entity: entity, dimensions: dimensions)
                    }
                    Spacer()
                }
            }
            .frame(height: .greedy)
        }
    }
}

#Preview {
    if #available(iOSApplicationExtension 16.1, *) {
        return TimerView(
            entities: [
                TimingEntity(event: EventEntity.random()),
                TimingEntity(event: EventEntity.random())
            ]
        )
    } else {
        return EmptyView()
    }
}
