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
    @Binding var task: EventObject?
    @Binding var isPresented: Bool

    @State private var startAt: Date!
    @State private var isWinnerPresented: Bool = false

    var time: Time { manager.time }

    @EnvironmentObject var manager: PomodoroManager

    var body: some View {
        GeometryReader { proxy in
            let minLenght = min(proxy.size.width, proxy.size.height)
            VStack {
                Spacer()

                Text(task?.name ?? R.string.localizable.tasks())
                    .font(.largeTitle)
                    .frame(width: .greedy)
                if let category = task?.category {
                    CategoryView(category: category)
                }

                Spacer()

                HStack {
                    let seconds = time.seconds
                    if time.hour > 0 {
                        Text("\(time.hourTens)\(time.hourOnes)")
                            .foregroundColor(seconds < 3600 ? .quaternaryLabel : .darkGray)
                        Text(":")
                            .foregroundColor(seconds < 3600 ? .quaternaryLabel : .darkGray)
                    }
                    Text("\(time.minuteTens)\(time.minuteOnes)")
                        .foregroundColor(seconds < 60 ? .quaternaryLabel : .darkGray)
                    Text(":")
                        .foregroundColor(seconds < 60 ? .quaternaryLabel : .darkGray)
                    Text("\(time.secondTens)\(time.secondOnes)")
                        .foregroundColor(seconds == 0 ? .quaternaryLabel : .darkGray)
                }
                .font(.system(size: floor(minLenght / 8), design: .rounded), weight: .bold)
                .monospacedDigit()

                Spacer(minLength: floor(minLenght * 0.6))

                button
                    .frame(width: 64, height: 64)

                Spacer()
            }
        }
        .ifLet(task?.color) {
            $0.background(LinearGradient(gradient: Gradient(colors: [$1, Color.white]), startPoint: .top, endPoint: .bottom))
        }
        .onChange(of: time) { _ in
            guard manager.state == .focusCompleted else { return }
            isWinnerPresented = true
        }
        .onAppear {
            manager.startFocus()
            startAt = time.date
        }
        // Popup winner
        .popup(isPresented: $isWinnerPresented, view: {
            WinnerView(onClose: {
                saveTaskItem()

                isWinnerPresented = false
            }, onFinish: {
                saveTaskItem()

                isWinnerPresented = false
                isPresented = false
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
        HoldOnButton(strokeColor: task!.color, action: {
            manager.stop()
            isPresented = false
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
            .background {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .foregroundStyle(task!.color.opacity(0.5))
            }
    }

    func saveTaskItem() {
        guard manager.state == .focusCompleted, let realm = task?.realm else {
            manager.stop()
            return
        }
        try? realm.write {
            let milliseconds = manager.focusMinutes * 60 * 1000 - time.milliseconds
            let item = RecordObject(creationMode: .timer, startAt: self.startAt, milliseconds: milliseconds)
            realm.add(item)

            task?.items.append(item)
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
    PomodoroView(task: .constant(EventObject(emoji: "👌", name: "Work", hex: HexObject(hex: ""))), isPresented: .constant(false))
        .environmentObject(TimerManager.shared)
}
