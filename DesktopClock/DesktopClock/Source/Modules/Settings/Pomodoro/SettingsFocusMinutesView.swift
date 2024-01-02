//
//  SettingsFocusMinutesView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsFocusMinutesView: View {
    @Binding var isPresented: Bool

    var pomodoro: PomodoroManager {
        PomodoroManager.shared
    }

    var body: some View {
        let options = pomodoro.focusMinutesOptions
        SettingsSection(title: R.string.localizable.focusDuration(), itemCount: options.count, scrollToID: pomodoro.focusMinutes) {
            ForEach(options, id: \.self) { option in
                SettingsCheckCell(title: "\(option) mins", isChecked: pomodoro.focusMinutes == option) {
                    pomodoro.focusMinutes = option
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsFocusMinutesView(isPresented: Binding<Bool>.constant(false))
}
