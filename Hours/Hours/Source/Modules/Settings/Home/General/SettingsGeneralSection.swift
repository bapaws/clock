//
//  SettingsGeneralSection.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsGeneralSection: View {
    @State private var isTimerPresented: Bool = false
    @State var isDarkModePresented: Bool = false
    @State var isAppIconPresented: Bool = false

    @State var isEmoji: Bool = UIManager.shared.iconType == .emoji

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: L10n.general) {
            SettingsNavigateCell(title: L10n.timer) {
                isTimerPresented.toggle()
            }

            SettingsNavigateCell(title: DarkMode.title, value: ui.darkMode.value) {
                isDarkModePresented = true
            }
            SettingsNavigateCell(title: AppIconType.title, value: ui.appIcon.value) {
                isAppIconPresented = true
            }
        }
        .background(ui.background)
        .sheet(isPresented: $isTimerPresented) {
            SettingsTimerSection()
                .environmentObject(TimerManager.shared)
        }
        .sheet(isPresented: $isDarkModePresented) {
            SettingsDarkModeView()
        }
        .sheet(isPresented: $isAppIconPresented) {
            SettingsAppIconView()
        }
    }
}

#Preview {
    SettingsGeneralSection()
}
