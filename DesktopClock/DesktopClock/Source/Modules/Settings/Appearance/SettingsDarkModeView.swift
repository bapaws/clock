//
//  SettingsDarkModeView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI

struct SettingsDarkModeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager
    
    var body: some View {
        SettingsSection(
            title: DarkMode.title,
            items: DarkMode.allCases.map { mode in
                SettingsItem(type: .check(mode.value, ui.darkMode == mode)) {
                    ui.darkMode = mode
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsDarkModeView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
