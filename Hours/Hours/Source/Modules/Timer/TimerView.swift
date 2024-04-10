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

struct TimerView: View {
    let event: EventObject

    @State var startAt: Date = .init()

    var time: Time { manager.time }

    @EnvironmentObject var manager: TimerManager
    @Environment(\.dismiss) var dismiss

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var app: AppManager

    var body: some View {
        VStack {
            HStack {
                if let emoji = event.categorys.first?.emoji {
                    Text(emoji)
                        .font(.largeTitle, weight: .black)
                    Text("•")
                        .font(.largeTitle, weight: .black)
                        .foregroundStyle(event.primary)
                }
                Text(event.name)
            }
            .font(.title)
            .frame(width: .greedy)
            .foregroundStyle(colorScheme == .dark ? event.primary : event.onPrimaryContainer)

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
            manager.start()
            startAt = time.date
        }
        .onDisappear {
            manager.stop()
        }
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playTimer()
        }
    }

    var stopButton: some View {
        HoldOnButton(strokeColor: event.primary, action: {
            onFinished()

        }) {
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
        manager.pause()
        dismiss()

        guard time.milliseconds > Int(AppManager.shared.minimumRecordedTime * 1000) else { return }
        guard let event = event.thaw(), let realm = event.realm else { return }

        try? realm.write {
            let item = RecordObject(creationMode: .timer, startAt: self.startAt, milliseconds: time.milliseconds)
            realm.add(item)

            event.items.append(item)
        }
    }
}

#Preview {
    TimerView(event: EventObject(emoji: "👌", name: "Work", hex: HexObject(hex: "#757573")))
        .environmentObject(TimerManager.shared)
}
