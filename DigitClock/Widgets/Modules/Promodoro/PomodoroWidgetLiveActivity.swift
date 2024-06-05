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
                    PomodoroWidget(context: context)
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
                        PomodoroWidget(context: context)
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
                    .padding(.leading, .small)
            } compactTrailing: {
                Text(timerInterval: context.state.range, countsDown: true, showsHours: false)
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                    .frame(width: 48)
                    .font(.body, weight: .thin)
                    .foregroundStyle(Color.white)
            } minimal: {
                Text(timerInterval: context.state.range, countsDown: true, showsHours: false)
                    .font(.callout, weight: .thin)
                    .minimumScaleFactor(0.2)
                    .foregroundStyle(Color.white)
            }
            .keylineTint(Color.black)
            .contentMargins(.horizontal, 32, for: .expanded)
        }
    }

    @ViewBuilder var releaseButton: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: StopLiveActivityIntent(), label: {
                Text(R.string.localizable.stop())
                    .font(.headline, weight: .ultraLight)
            })
        } else {
            Text(R.string.localizable.stop())
                .font(.headline, weight: .ultraLight)
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
