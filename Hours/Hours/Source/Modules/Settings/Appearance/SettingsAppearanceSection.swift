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
    @Binding var isDarkModePresented: Bool
    @Binding var isLandspaceModePresented: Bool

    @State var isEmoji: Bool = UIManager.shared.iconType == .emoji

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.appearance()) {
            SettingsNavigateCell(title: DarkMode.title, value: ui.darkMode.value) {
                isDarkModePresented = true
            }

            // pad 下横竖屏切换无效
            if UIDevice.current.userInterfaceIdiom != .pad {
                SettingsNavigateCell(title: LandspaceMode.title, value: ui.landspaceMode.value) {
                    isLandspaceModePresented = true
                }
            }
        }
    }
}

#Preview {
    SettingsAppearanceSection(
        isDarkModePresented: Binding<Bool>.constant(false),
        isLandspaceModePresented: Binding<Bool>.constant(false)
    )
}
