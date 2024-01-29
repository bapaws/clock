//
//  SettingsClockSection.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct SettingsPomodoroSection: View {
    @EnvironmentObject var pomodoro: PomodoroManager

    var body: some View {
        SettingsStepperCell(title: R.string.localizable.focusDuration() + " (mins)", value: focusMinutes, minimumValue: 5, maximumValue: 180)
            .padding(.horizontal)
        SettingsStepperCell(title: R.string.localizable.shortBreakDuration() + " (mins)", value: shortBreakMinutes, minimumValue: 1, maximumValue: 30)
            .padding(.horizontal)
    }

    var focusMinutes: Binding<Double> {
        Binding<Double>(get: { Double(pomodoro.focusMinutes) }, set: { pomodoro.focusMinutes = Int($0) })
    }

    var shortBreakMinutes: Binding<Double> {
        Binding<Double>(get: { Double(pomodoro.shortBreakMinutes) }, set: { pomodoro.shortBreakMinutes = Int($0) })
    }
}

#Preview {
    SettingsPomodoroSection()
        .environmentObject(PomodoroManager.shared)
}
