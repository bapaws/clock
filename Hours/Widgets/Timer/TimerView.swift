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
    private let event: EventObject

    init(context: ActivityViewContext<TimerActivityAttributes>) {
        self.time = context.state.time
        self.event = context.attributes.event
    }

    init(time: Time, event: EventObject) {
        self.time = time
        self.event = event
    }

    var body: some View {
        VStack {
            Text(event.title)
                .font(.title)
                .frame(width: .greedy)
                .foregroundStyle(event.primary)

            Spacer()

            Text(timerInterval: time.date ... time.date.addingTimeInterval(6 * 60 * 60), countsDown: false)
                .contentTransition(.numericText(countsDown: true))
                .font(.largeTitle, weight: .bold)
                .monospacedDigit()

            Spacer()

            stopButton
                .frame(width: 64, height: 64)
        }
    }

    var stopButton: some View {
        Button {
            onFinished()
        } label: {
            buttonLabel(systemName: "stop")
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

    private var zeroNumberColor: Color {
        numberColor.opacity(0.5)
    }

    private var numberColor: Color {
        colorScheme == .dark ? event.onPrimary : event.primary
    }

    private var linearGradient: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(gradient: Gradient(colors: [event.onPrimary, event.onPrimaryContainer]), startPoint: .top, endPoint: .bottom)
        } else {
            LinearGradient(gradient: Gradient(colors: [event.primaryContainer, event.background]), startPoint: .top, endPoint: .bottom)
        }
    }

    private func onFinished() {}
}

#Preview {
    if #available(iOSApplicationExtension 16.1, *) {
        return TimerView(
            time: Time(),
            event: EventObject(emoji: "🛌", name: R.string.localizable.sleep(), hex: HexObject(hex: "C9D8CD"), isSystem: true)
        )
    }
}
