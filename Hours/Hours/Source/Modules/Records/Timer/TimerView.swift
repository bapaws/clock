//
//  TimerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX
import UIKit

struct TimerView: View {
    let event: EventEntity

    var time: Time { manager.time }

    // Timer Stop from live activity
    let timerStop = NotificationCenter.default
        .publisher(for: TimerManager.shared.timerStop)

    @EnvironmentObject var manager: HoursShare.TimerManager
    @Environment(\.dismiss) var dismiss

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var app: AppManager

    var body: some View {
        VStack {
            Text(event.title)
                .font(.title)
                .frame(width: .greedy)
                .foregroundStyle(event.primary)

            Spacer()

            HStack {
                let seconds = time.seconds
                if manager.hourStyle != .none || time.hour > 0 {
                    Text("\(time.hourTens)\(time.hourOnes)")
                        .foregroundColor(seconds < 3600 ? zeroNumberColor : numberColor)
                    Text(":")
                        .foregroundColor(seconds < 3600 ? zeroNumberColor : numberColor)
                }

                Text("\(time.minuteTens)\(time.minuteOnes)")
                    .foregroundColor(seconds < 60 ? zeroNumberColor : numberColor)
                Text(":")
                    .foregroundColor(seconds < 60 ? zeroNumberColor : numberColor)
                Text("\(time.secondTens)\(time.secondOnes)")
                    .foregroundColor(seconds == 0 ? zeroNumberColor : numberColor)
            }
            .contentTransition(.numericText(countsDown: true))
            .font(.system(size: 66, design: .rounded), weight: .bold)
            .monospacedDigit()

            Spacer()

            stopButton
                .frame(width: 64, height: 64)
        }
        .padding(.vertical, .extraLarge)
        .padding(.vertical, .extraExtraLarge)
        .background(linearGradient)
        .onAppear {
            manager.start(of: TimingEntity(event: event))
        }
        .onDisappear {
            manager.stop()
        }
        .onChange(of: manager.time.seconds) { newValue in
            if newValue >= Int(app.maximumRecordedTime) {
                onFinished()
            } else {
                AppManager.shared.playTimer()
            }
        }
        .onReceive(timerStop) { _ in
            dismiss()
        }
    }

    var stopButton: some View {
        Button {
            onFinished()
        } label: {
            buttonLabel(systemName: "stop")
        }
    }

    func buttonLabel(systemName: String) -> some View {
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

    var zeroNumberColor: Color {
        numberColor.opacity(0.5)
    }

    var numberColor: Color {
        colorScheme == .dark ? event.onPrimary : event.primary
    }

    var linearGradient: LinearGradient {
        if colorScheme == .dark {
            LinearGradient(gradient: Gradient(colors: [event.onPrimary, event.onPrimaryContainer]), startPoint: .top, endPoint: .bottom)
        } else {
            LinearGradient(gradient: Gradient(colors: [event.primaryContainer, event.background]), startPoint: .top, endPoint: .bottom)
        }
    }

    func onFinished() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()

        manager.pause()
        dismiss()

        guard time.milliseconds > Int(app.minimumRecordedTime * 1000) else { return }

        Task {
            let milliseconds = min(time.milliseconds, Int(app.maximumRecordedTime * 1000))
            var newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
            // 同步到日历应用
            let eventIdendtifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
            newRecord.calendarEventIdentifier = eventIdendtifier
            await AppRealm.shared.writeRecord(newRecord, addTo: event)
        }

        // 发起 App Store 评论请求
        AppManager.shared.requestReview(delay: 2)
    }
}

#Preview {
    TimerView(event: EventEntity(emoji: "👌", name: "Work", hex: HexEntity(hex: "#757573")))
        .environmentObject(TimerManager.shared)
}
