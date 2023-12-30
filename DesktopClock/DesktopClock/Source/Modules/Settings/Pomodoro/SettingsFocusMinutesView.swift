//
//  SettingsFocusMinutesView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI
import ClockShare

struct SettingsFocusMinutesView: View {
    @Binding var isPresented: Bool

    var pomodoro: PomodoroManager {
        PomodoroManager.shared
    }

    var body: some View {
        SettingsSection(
            title: R.string.localizable.focusDuration(),
            items: pomodoro.focusMinutesOptions.map { option in
                SettingsItem(type: .check("\(option) mins", pomodoro.focusMinutes == option)) {
                    pomodoro.focusMinutes = option
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsFocusMinutesView(isPresented: Binding<Bool>.constant(false))
}
