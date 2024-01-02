//
//  SettingsClockSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsPomodoroSection: View {
    @Binding var isPaywallPresented: Bool
    @Binding var isFocusPresented: Bool
    @Binding var isShortBreakPresented: Bool
    @Binding var isLongBreakPresented: Bool

    @EnvironmentObject var pomodoro: PomodoroManager

    var body: some View {
        SettingsSection(title: R.string.localizable.pomodoro()) {
            SettingsNavigateCell(title: R.string.localizable.focusDuration(), value: "\(pomodoro.focusMinutes) mins", isPro: true) {
                if ProManager.default.pro {
                    isFocusPresented = true
                } else {
                    isPaywallPresented = true
                }
            }
            SettingsNavigateCell(title: R.string.localizable.shortBreakDuration(), value: "\(pomodoro.shortBreakMinutes) mins", isPro: true) {
                if ProManager.default.pro {
                    isShortBreakPresented = true
                } else {
                    isPaywallPresented = true
                }
            }
        }
    }
}

#Preview {
    SettingsPomodoroSection(
        isPaywallPresented: Binding<Bool>.constant(false),
        isFocusPresented: Binding<Bool>.constant(false),
        isShortBreakPresented: Binding<Bool>.constant(false),
        isLongBreakPresented: Binding<Bool>.constant(false)
    )
    .environmentObject(PomodoroManager.shared)
}
