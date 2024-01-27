//
//  PomodoroWidgetLiveActivity.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ActivityKit
import ClockShare
import DigitalClockShare
import Foundation
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOSApplicationExtension 16.1, *)
struct PomodoroWidgetLiveActivity: Widget {
    let padding: CGFloat = 16
    let spacing: CGFloat = 16
    let colonWidth: CGFloat = 24

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            HStack {
                VStack(alignment: .leading) {
                    Text(context.attributes.state.value)
                        .font(.headline, weight: .thin)
                        .foregroundStyle(Color.white)
                    PomodoroWidget(time: context.state.time)
                        .foregroundStyle(Color.white)
                        .frame(width: 224)
                }
                Spacer()
                VStack {
                    Spacer()
                    releaseButton
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .tint(Color.white)
                        .cornerRadius(32, style: .circular)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical)
            .background(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading, priority: 0.75) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.state.value)
                            .font(.headline, weight: .thin)
                            .foregroundStyle(Color.white)
                        PomodoroWidget(time: context.state.time)
                            .foregroundStyle(Color.white)
                            .frame(width: 224)
                    }
                }
                DynamicIslandExpandedRegion(.trailing, priority: 0.25) {
                    VStack {
                        Spacer()
                        releaseButton
                            .foregroundStyle(Color.black)
                            .background(Color.white)
                            .tint(Color.white)
                            .cornerRadius(32, style: .circular)
                    }
                }
            } compactLeading: {
                Image("lightClassicMini")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(width: 24, height: 24)
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
            .keylineTint(Color.black)
            .contentMargins(.horizontal, 32, for: .expanded)
        }
    }

    @ViewBuilder var releaseButton: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: StopLiveActivityIntent(), label: {
                Text(R.string.localizable.stop())
                    .font(.headline)
            })
        } else {
            Text(R.string.localizable.stop())
                .font(.headline)
                .padding(.horizontal, .regular)
                .padding(.vertical, .small)
        }
    }
}

// MARK: Preview

private extension DigitalClockShare.PomodoroAttributes {
    static var preview: DigitalClockShare.PomodoroAttributes {
        DigitalClockShare.PomodoroAttributes(seconds: 25 * 60, state: .shortBreak)
    }
}

private extension DigitalClockShare.PomodoroAttributes.ContentState {
    static var focus: DigitalClockShare.PomodoroAttributes.ContentState {
        DigitalClockShare.PomodoroAttributes.ContentState(time: Time(hour: 0, minute: 20, second: 30))
    }

    static var shortBreak: DigitalClockShare.PomodoroAttributes.ContentState {
        DigitalClockShare.PomodoroAttributes.ContentState(time: Time.shortBreak)
    }
}

@available(iOS 17.0, *)
#Preview("Notification", as: .content, using: DigitalClockShare.PomodoroAttributes.preview) {
    PomodoroWidgetLiveActivity()
} contentStates: {
    DigitalClockShare.PomodoroAttributes.ContentState.focus
    DigitalClockShare.PomodoroAttributes.ContentState.shortBreak
}

// @available(iOS 17.0, *)
// #Preview("DynamicIsland.minimal", as: .dynamicIsland(.minimal), using: PomodoroAttributes.preview) {
//    PomodoroWidgetLiveActivity()
// } contentStates: {
//    PomodoroAttributes.ContentState.focus
//    PomodoroAttributes.ContentState.shortBreak
// }
//
// @available(iOS 17.0, *)
// #Preview("DynamicIsland.compact", as: .dynamicIsland(.compact), using: PomodoroAttributes.preview) {
//    PomodoroWidgetLiveActivity()
// } contentStates: {
//    PomodoroAttributes.ContentState.focus
//    PomodoroAttributes.ContentState.shortBreak
// }
//
// @available(iOS 17.0, *)
// #Preview("DynamicIsland.expanded", as: .dynamicIsland(.expanded), using: PomodoroAttributes.preview) {
//    PomodoroWidgetLiveActivity()
// } contentStates: {
//    PomodoroAttributes.ContentState.focus
//    PomodoroAttributes.ContentState.shortBreak
// }
