//
//  SettingsLongBreakMinutesView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct SettingsLongBreakMinutesView: View {
    @Binding var isPresented: Bool

    var pomodoro: PomodoroManager {
        PomodoroManager.shared
    }

    var body: some View {
        SettingsSection(title: R.string.localizable.longBreakDuration()) {
            ForEach(pomodoro.longBreakMinuteOptions, id: \.self) { option in
                SettingsCheckCell(title: "\(option) mins", isChecked: pomodoro.longBreakMinutes == option) {
                    pomodoro.longBreakMinutes = option
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsShortBreakMinutesView(isPresented: Binding<Bool>.constant(false))
}
