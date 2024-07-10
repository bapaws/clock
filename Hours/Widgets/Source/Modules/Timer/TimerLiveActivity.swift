//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by 张敏超 on 2024/5/22.
//

import ActivityKit
import ClockShare
import HoursShare
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOS 16.1, *)
struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<TimingEntityActivityAttributes>(for: TimingEntityActivityAttributes.self) { context in
            TimerView(context: context)
                .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                let entities = context.state
                DynamicIslandExpandedRegion(.leading) {
                    Text(R.string.localizable.tracking("\(entities.count)"))
                        .font(.headline)
                        .padding(.leading, .small)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    if let icon = R.image.icon() {
                        Image(uiImage: icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .cornerRadius(4)
                            .padding(.trailing, .small)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if entities.count == 1 {
                        TimerView(context: context)
                    } else {
                        let space: CGFloat = 8
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
            } compactLeading: {
                if let emoji = context.state.first?.emoji {
                    Text(emoji)
                } else {
                    Image("Icon")
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
                }
            } compactTrailing: {
                Group {
                    if let event = context.state.first {
                        let time = event.time
                        Text(timerInterval: time.date ... time.date.addingTimeInterval(6 * 60 * 60), countsDown: false)
                            .foregroundStyle(event.darkPrimary)
                    } else {
                        Text("-:--")
                    }
                }
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .frame(minWidth: 36, maxWidth: 54, alignment: .leading)
                .monospacedDigit()
            } minimal: {
                if let emoji = context.state.first?.emoji {
                    Text(emoji)
                } else {
                    Image("Icon")
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
                }
            }
        }
    }
}

// #Preview("Notification", as: .content, using: TimerActivityAttributes.preview) {
//    TimerLiveActivity()
// } contentStates: {
//    TimerActivityAttributes.ContentState(time: Time())
// }
