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

    private let time: Time
    private let event: TimingEntity

    init(context: ActivityViewContext<TimerActivityAttributes>) {
        self.time = context.state.time
        self.event = context.attributes.event
    }

    init(time: Time, event: TimingEntity) {
        self.time = time
        self.event = event
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                if let emoji = event.emoji {
                    Text(emoji)
                        .font(.title2)
                }
                Text(event.name)
                    .font(.title2)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(event.lightPrimary)
                Spacer()
            }
            HStack {
                Text(timerInterval: time.initialDate ... time.date.addingTimeInterval(6 * 60 * 60), countsDown: false)
                    .contentTransition(.numericText(countsDown: false))
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundStyle(event.darkPrimary)
                    .monospacedDigit()

                Spacer()

                stopButton(for: event)
            }
        }
    }

    @ViewBuilder func stopButton(for event: TimingEntity) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            Button(intent: StopTimerLiveActivityIntent(), label: {
                Image(systemName: "stop.fill")
                    .font(.title2)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(event.darkPrimary)
                    .background(event.darkOnPrimary)
                    .cornerRadius(30)
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

    private func buttonLabel(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.title3)
            .padding().padding(.small)
            .foregroundStyle(colorScheme == .dark ? event.onPrimary : event.primary)
            .background {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(colorScheme == .dark ? event.onPrimaryContainer : event.primaryContainer)
            }
    }

    private var linearGradient: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(gradient: Gradient(colors: [event.onPrimary, event.onPrimaryContainer]), startPoint: .leading, endPoint: .trailing)
        } else {
            LinearGradient(gradient: Gradient(colors: [event.primaryContainer, event.background]), startPoint: .leading, endPoint: .trailing)
        }
    }

    private func onFinished() {}
}

#Preview {
    if #available(iOSApplicationExtension 16.1, *) {
        return TimerView(
            time: Time(),
            event: TimingEntity.random()
        )
    } else {
        return EmptyView()
    }
}