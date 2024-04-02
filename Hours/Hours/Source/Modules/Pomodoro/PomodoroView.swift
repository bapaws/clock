//
//  PomodoroView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/15.
//

import ActivityKit
import ClockShare
import Combine
import HoursShare
import PopupView
import SwiftUI

struct PomodoroView: View {
    let event: EventObject

    @State private var startAt: Date!
    @State private var isWinnerPresented: Bool = false

    var time: Time { manager.time }

    @EnvironmentObject var manager: PomodoroManager
    @Environment(\.dismiss) var dismiss

    @Environment(\.colorScheme) var colorScheme

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
                if time.hour > 0 {
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
            .contentTransition(.numericText())
            .font(.system(size: 66, design: .rounded), weight: .bold)
            .monospacedDigit()

            Spacer()

            button
                .frame(width: 64, height: 64)
        }
        .padding(.vertical, .extraLarge)
        .padding(.vertical, .extraExtraLarge)
        .background(linearGradient)
        .onChange(of: time) { _ in
            guard manager.state == .focusCompleted else { return }
            isWinnerPresented = true
        }
        .onAppear {
            manager.startFocus()
            startAt = time.date
        }
        .onDisappear {
            manager.stop()
        }
        .onChange(of: manager.time.seconds) { _ in
            AppManager.shared.playPomodoro()
        }
        // Popup winner
        .popup(isPresented: $isWinnerPresented, view: {
            WinnerView(onClose: {
                saveTaskItem()

                isWinnerPresented = false
            }, onFinish: {
                saveTaskItem()

                isWinnerPresented = false
                dismiss()
            }, onBreak: {
                saveTaskItem()
                manager.startShortBreak()

                isWinnerPresented = false
            })
        }, customize: customize)
    }

    @ViewBuilder var button: some View {
        if manager.state == .none {
            startButton
        } else if manager.state == .focusCompleted {
            shortBreakButton
        } else {
            stopButton
        }
    }

    var stopButton: some View {
        HoldOnButton(strokeColor: event.primary, action: {
            manager.stop()
            dismiss()
        }) {
            buttonLabel(systemName: "stop")
        }
    }

    var startButton: some View {
        Button(action: {
            manager.startFocus()
        }) {
            buttonLabel(systemName: "play")
        }
    }

    var restartButton: some View {
        Button(action: manager.restartFocusTimer) {
            buttonLabel(systemName: "goforward")
        }
    }

    var shortBreakButton: some View {
        Button(action: {
            manager.startShortBreak()
        }) {
            buttonLabel(systemName: "cup.and.saucer")
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
        colorScheme == .dark ? event.onSurfaceVariant : event.surfaceVariant
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

    func saveTaskItem() {
        guard manager.state == .focusCompleted, let event = event.thaw(), let realm = event.realm else {
            manager.stop()
            return
        }
        try? realm.write {
            let milliseconds = manager.focusMinutes * 60 * 1000 - time.milliseconds
            let item = RecordObject(creationMode: .timer, startAt: self.startAt, milliseconds: milliseconds)
            realm.add(item)

            event.items.append(item)
        }
    }

    func customize<PopupContent: View>(parameters: Popup<PopupContent>.PopupParameters) -> Popup<PopupContent>.PopupParameters {
        parameters
            .appearFrom(.bottom)
            .closeOnTapOutside(false)
            .isOpaque(true)
            .animation(.spring(duration: 0.3))
    }
}

#Preview {
    PomodoroView(event: EventObject(emoji: "👌", name: "Work", hex: HexObject(hex: "")))
        .environmentObject(TimerManager.shared)
}
