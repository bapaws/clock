//
//  PomodoroWidgetLiveActivity.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/10.
//

import ActivityKit
import ClockShare
import DeskClockShare
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
                    PomodoroWidget(context: context)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .frame(width: .greedy)
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
                    VStack(alignment: .leading, spacing: 16) {
                        Text(context.attributes.state.value)
                            .font(.headline)
                            .foregroundStyle(context.attributes.colors.primary)
                        PomodoroWidget(context: context)
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .frame(width: 280)
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
                Text(timerInterval: context.state.range, countsDown: true, showsHours: false)
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .frame(width: 48)
                    .foregroundColor(context.attributes.colors.primary)
            } minimal: {
                Text(timerInterval: context.state.range, countsDown: true, showsHours: false)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .minimumScaleFactor(0.2)
                    .foregroundColor(context.attributes.colors.primary)
            }
            .keylineTint(context.attributes.colors.primary)
            .contentMargins(.horizontal, 32, for: .expanded)
        }
    }

    @ViewBuilder func releaseButton(for context: ActivityViewContext<DeskClockShare.PomodoroAttributes>) -> some View {
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

private extension DeskClockShare.PomodoroAttributes {
    static var preview: DeskClockShare.PomodoroAttributes {
        DeskClockShare.PomodoroAttributes(seconds: 25 * 60, state: .shortBreak)
    }
}

private extension DeskClockShare.PomodoroAttributes.ContentState {
    static var focus: DeskClockShare.PomodoroAttributes.ContentState {
        DeskClockShare.PomodoroAttributes.ContentState(time: Time(hour: 0, minute: 20, second: 30))
    }

    static var shortBreak: DeskClockShare.PomodoroAttributes.ContentState {
        DeskClockShare.PomodoroAttributes.ContentState(time: Time.shortBreak)
    }
}

@available(iOS 17.0, *)
#Preview("Notification", as: .content, using: DeskClockShare.PomodoroAttributes.preview) {
    PomodoroWidgetLiveActivity()
} contentStates: {
    DeskClockShare.PomodoroAttributes.ContentState.focus
    DeskClockShare.PomodoroAttributes.ContentState.shortBreak
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
