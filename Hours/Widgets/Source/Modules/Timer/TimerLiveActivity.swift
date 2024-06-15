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
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            TimerView(context: context)
                .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    TimerView(context: context)
                        .padding(.bottom)
                }
            } compactLeading: {
                if let emoji = context.attributes.event.emoji {
                    Text(emoji)
                } else {
                    Image("Icon")
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
                }
            } compactTrailing: {
                let event = context.attributes.event
                let time = context.state.time
                Text(timerInterval: time.date ... time.date.addingTimeInterval(6 * 60 * 60), countsDown: false)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .frame(minWidth: 36, maxWidth: 54, alignment: .leading)
                    .foregroundStyle(event.darkPrimary)
                    .monospacedDigit()
            } minimal: {
                if let emoji = context.attributes.event.emoji {
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
