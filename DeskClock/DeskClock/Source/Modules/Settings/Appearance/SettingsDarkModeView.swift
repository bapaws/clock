//
//  SettingsDarkModeView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct SettingsDarkModeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: DarkMode.title) {
            ForEach(DarkMode.allCases, id: \.self) { mode in
                SettingsCheckCell(title: mode.value, isChecked: ui.darkMode == mode) {
                    ui.darkMode = mode
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsDarkModeView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
