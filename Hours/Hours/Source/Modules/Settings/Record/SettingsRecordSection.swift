//
//  SettingsRecordSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsRecordSection: View {
    @State var isTimingModePresented: Bool = false
    @State var isPomodoroPresented: Bool = false
    @State var isTimerPresented: Bool = false

    var isInfinity: Binding<Bool> {
        Binding(get: {
            AppManager.shared.timingMode == .timer
        }, set: { newValue in
            AppManager.shared.timingMode = newValue ? .timer : .pomodoro
        })
    }

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: R.string.localizable.records()) {
            SettingsNavigateCell(title: R.string.localizable.timingMode(), value: app.timingMode.value) {
                isTimingModePresented = true
            }

            SettingsNavigateCell(title: R.string.localizable.pomodoro()) {
                isPomodoroPresented = true
            }

            SettingsNavigateCell(title: R.string.localizable.timer()) {
                isTimerPresented = true
            }
        }
        .sheet(isPresented: $isTimingModePresented) {
            SettingsTimingModeSection()
        }
        .sheet(isPresented: $isPomodoroPresented) {
            SettingsPomodoroSection()
                .environmentObject(PomodoroManager.shared)
        }
        .sheet(isPresented: $isTimerPresented) {
            SettingsTimerSection()
                .environmentObject(TimerManager.shared)
        }
    }
}

#Preview {
    SettingsRecordSection()
}
