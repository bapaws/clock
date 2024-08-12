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
        if entities.count == 1, let event = entities.first {
            VStack(spacing: 8) {
                HStack {
                    if let emoji = event.emoji, !emoji.isEmpty {
                        Text(emoji)
                            .font(.title3)
                    }
                    Text(event.name)
                        .font(.title2)
                        .foregroundStyle(event.lightPrimary)
                    Spacer()
                }

                HStack {
                    Text(timerInterval: event.timerInterval, countsDown: false)
                        .contentTransition(.numericText(countsDown: false))
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                        .foregroundStyle(event.darkPrimary)
                        .monospacedDigit()
                    Spacer()
                    stopButton(for: event)
                }
            }
            .padding(.horizontal)

        } else {
            VStack(spacing: 12) {
                HStack {
                    Text(L10n.tracking("\(entities.count)"))
                        .font(.headline)

                    Spacer()

                    Image(asset: Asset.icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(4)
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

    @ViewBuilder func stopButton(for event: TimingEntity) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: QuickStopTimerAppIntent(eventID: event.id), label: {
                Image(systemName: "stop.fill")
                    .font(.system(.title2, design: .rounded))
                    .foregroundStyle(event.primary)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(event.primaryContainer)
                    }
            })
            .background(.clear)
            .buttonStyle(BorderlessButtonStyle())
        } else {
            Image(systemName: "stop.fill")
                .font(.title2)
                .frame(width: 60, height: 60)
                .foregroundStyle(event.darkPrimary)
                .background(event.darkOnPrimary)
                .cornerRadius(30)
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
