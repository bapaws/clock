//
//  SettingsAppearanceSection.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsAppearanceSection: View {
    @State var isDarkModePresented: Bool = false
    @State var isAppIconPresented: Bool = false

    @State var isEmoji: Bool = UIManager.shared.iconType == .emoji

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.appearance()) {
            SettingsNavigateCell(title: DarkMode.title, value: ui.darkMode.value) {
                isDarkModePresented = true
            }
            SettingsNavigateCell(title: AppIconType.title, value: ui.appIcon.value) {
                isAppIconPresented = true
            }
        }
        .background(ui.background)
        .sheet(isPresented: $isDarkModePresented) {
            SettingsDarkModeView()
        }
        .sheet(isPresented: $isAppIconPresented) {
            SettingsAppIconView()
        }
    }
}

#Preview {
    SettingsAppearanceSection()
}
