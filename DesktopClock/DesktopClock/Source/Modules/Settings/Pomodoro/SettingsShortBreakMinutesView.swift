//
//  SettingsShortBreakMinutesView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsShortBreakMinutesView: View {
    @Binding var isPresented: Bool

    var pomodoro: PomodoroManager {
        PomodoroManager.shared
    }

    var body: some View {
        let options = pomodoro.shortBreakMinuteOptions
        SettingsSection(title: R.string.localizable.shortBreakDuration(), itemCount: options.count, scrollToID: pomodoro.shortBreakMinutes) {
            ForEach(options, id: \.self) { option in
                SettingsCheckCell(title: "\(option) mins", isChecked: pomodoro.shortBreakMinutes == option) {
                    pomodoro.shortBreakMinutes = option
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsShortBreakMinutesView(isPresented: Binding<Bool>.constant(false))
}
