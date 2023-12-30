//
//  SettingsAppearanceSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI

struct SettingsAppearanceSection: View {
    @Binding var isPaywallPresented: Bool
    @Binding var isDarkModePresented: Bool
    @Binding var isLandspaceModePresented: Bool
    @Binding var isContentsModePresented: Bool
    @Binding var isColorStylePresented: Bool

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(
            title: R.string.localizable.appearance(),
            items: [
                SettingsItem(type: .popup(DarkMode.title, ui.darkMode.value), action: {
                    isDarkModePresented = true
                }),
                SettingsItem(type: .popup(LandspaceMode.title, ui.landspaceMode.value), action: {
                    isLandspaceModePresented = true
                }),
                SettingsItem(type: .popup(IconType.title, ui.iconType.value), isPro: true) {
                    if ProManager.default.pro {
                        isContentsModePresented = true
                    } else {
                        isPaywallPresented = true
                    }
                },
                SettingsItem(type: .popup(ColorType.title, ui.colorType.value), isPro: true) {
                    if ProManager.default.pro {
                        isColorStylePresented = true
                    } else {
                        isPaywallPresented = true
                    }
                },
            ]
        )
    }
}

#Preview {
    SettingsAppearanceSection(
        isPaywallPresented: Binding<Bool>.constant(false),
        isDarkModePresented: Binding<Bool>.constant(false),
        isLandspaceModePresented: Binding<Bool>.constant(false),
        isContentsModePresented: Binding<Bool>.constant(false),
        isColorStylePresented: Binding<Bool>.constant(false)
    )
}
