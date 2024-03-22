//
//  SettingsClockSection.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsPomodoroSection: View {
    @EnvironmentObject var pomodoro: PomodoroManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SettingsStepperCell(title: R.string.localizable.focusDuration() + " (mins)", value: focusMinutes, minimumValue: 5, maximumValue: 180, stepValue: 5)

                SettingsStepperCell(title: R.string.localizable.shortBreakDuration() + " (mins)", value: shortBreakMinutes, minimumValue: 1, maximumValue: 30)

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(R.string.localizable.pomodoro())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .background(ui.background)
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
