//
//  SettingsShortBreakMinutesView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI
import ClockShare

struct SettingsShortBreakMinutesView: View {
    @Binding var isPresented: Bool

    var pomodoro: PomodoroManager {
        PomodoroManager.shared
    }

    var body: some View {
        SettingsSection(
            title: R.string.localizable.shortBreakDuration(),
            items: pomodoro.shortBreakMinuteOptions.map { option in
                SettingsItem(type: .check("\(option) mins", pomodoro.shortBreakMinutes == option)) {
                    pomodoro.shortBreakMinutes = option
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsShortBreakMinutesView(isPresented: Binding<Bool>.constant(false))
}
