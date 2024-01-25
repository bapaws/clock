//
//  PomodoroWidgetLiveActivity.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ActivityKit
import ClockShare
import DesktopClockShare
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
                        .font(.subheadline)
                        .foregroundStyle(context.attributes.colors.primary)
                    PomodoroWidget(time: context.state.time, colorType: context.attributes.colorType, colors: context.attributes.colors)
                }
                Spacer()
                VStack {
                    Spacer()
                    releaseButton(for: context)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical)
            .background(context.attributes.colors.background)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.state.value)
                            .font(.headline)
                            .foregroundStyle(context.attributes.colors.primary)
                        PomodoroWidget(time: context.state.time, colorType: context.attributes.colorType, colors: context.attributes.colors)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()
                        releaseButton(for: context)
                    }
                }
            } compactLeading: {
                Image("\(context.attributes.appIcon)Mini")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(width: 21, height: 21)
            } compactTrailing: {
                let time = context.state.time
                Text("\(time.minuteTens)\(time.minuteOnes):\(time.secondTens)\(time.secondOnes)")
                    .font(.body, weight: .bold)
                    .foregroundStyle(context.attributes.colors.primary)
            } minimal: {
                let time = context.state.time
                let total = Double(context.attributes.minutes * 60)
                let progress = (total - Double(time.seconds)) / total
                ProgressView(value: progress, total: total) {
                    Text("\(time.secondTens)\(time.secondOnes)")
                        .font(.callout, weight: .bold)
                        .foregroundStyle(context.attributes.colors.primary)
                }
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 23, height: 23)
            }
            .keylineTint(context.attributes.colors.primary)
            .contentMargins(.horizontal, 32, for: .expanded)
        }
    }

    @ViewBuilder func releaseButton(for context: ActivityViewContext<DesktopClockShare.PomodoroAttributes>) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: StopLiveActivityIntent(), label: {
                Text(R.string.localizable.stop())
                    .font(.headline)
                    .foregroundColor(context.attributes.colors.background)
            })
            .tint(context.attributes.colors.primary)
            .background(context.attributes.colors.primary)
            .cornerRadius(32, style: .circular)
        } else {
            Text(R.string.localizable.stop())
                .font(.headline)
                .padding(.horizontal, .regular)
                .padding(.vertical, .small)
                .foregroundColor(context.attributes.colors.background)
                .background(context.attributes.colors.primary)
                .cornerRadius(32, style: .circular)
        }
    }
}

// MARK: Preview

private extension DesktopClockShare.PomodoroAttributes {
    static var preview: DesktopClockShare.PomodoroAttributes {
        DesktopClockShare.PomodoroAttributes(minutes: 25, state: .shortBreak)
    }
}

private extension DesktopClockShare.PomodoroAttributes.ContentState {
    static var focus: DesktopClockShare.PomodoroAttributes.ContentState {
        DesktopClockShare.PomodoroAttributes.ContentState(time: Time(hour: 0, minute: 20, second: 30))
    }

    static var shortBreak: DesktopClockShare.PomodoroAttributes.ContentState {
        DesktopClockShare.PomodoroAttributes.ContentState(time: Time.shortBreak)
    }
}

@available(iOS 17.0, *)
#Preview("Notification", as: .content, using: DesktopClockShare.PomodoroAttributes.preview) {
    PomodoroWidgetLiveActivity()
} contentStates: {
    DesktopClockShare.PomodoroAttributes.ContentState.focus
    DesktopClockShare.PomodoroAttributes.ContentState.shortBreak
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
