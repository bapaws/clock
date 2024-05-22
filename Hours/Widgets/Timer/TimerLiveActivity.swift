//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by 张敏超 on 2024/5/22.
//

import ActivityKit
import HoursShare
import SwiftUI
import WidgetKit

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            TimerView(context: context)
                .activityBackgroundTint(Color.cyan)
                .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            let time = context.state.time
            let event = context.attributes.event
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Text(event.title)
                            .font(.title)
                            .foregroundStyle(event.primary)

                        Text(timerInterval: time.date ... time.date.addingTimeInterval(6 * 60 * 60), countsDown: false)
                            .contentTransition(.numericText(countsDown: true))
                            .font(.largeTitle, weight: .bold)
                            .monospacedDigit()
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()

                        Button(intent: StopTimerLiveActivityIntent()) {
                            Image(systemName: "stop")
                                .font(.title3)
                                .padding().padding(.small)
                                .foregroundStyle(event.onPrimary)
                                .background {
                                    Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                        .foregroundStyle(event.onPrimaryContainer)
                                }
                        }
                    }
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                let time = context.state.time
                Text("\(time.minuteTens)\(time.minuteOnes):\(time.secondTens)\(time.secondOnes)")
                    .font(.body, weight: .thin)
                    .foregroundStyle(Color.white)
            } minimal: {
                let time = context.state.time
                let total = Double(context.attributes.seconds)
                ProgressView(value: total - Double(time.seconds), total: total) {
                    Text("\(time.secondTens)\(time.secondOnes)")
                        .font(.callout, weight: .thin)
                        .foregroundStyle(Color.white)
                }
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 23, height: 23)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

#Preview("Notification", as: .content, using: TimerActivityAttributes.preview) {
    TimerLiveActivity()
} contentStates: {
    TimerAttributes.ContentState(time: Time())
}
