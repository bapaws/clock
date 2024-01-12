//
//  SettingsAppearanceSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsAppearanceSection: View {
    @Binding var isPaywallPresented: Bool
    @Binding var isDarkModePresented: Bool
    @Binding var isLandspaceModePresented: Bool
    @Binding var isContentsModePresented: Bool
    @Binding var isColorsPresented: Bool
    @Binding var isAppIconPresented: Bool

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
            SettingsNavigateCell(title: AppIconType.title, value: ui.appIcon.value) {
                isAppIconPresented = true
            }
            SettingsNavigateCell(title: ColorType.title, value: ui.colorType.value, isPro: true) {
                if ProManager.default.isPro {
                    isColorsPresented = true
                } else {
                    isPaywallPresented = true
                }
            }
            SettingsToggleCell(title: IconType.title, isPro: true, isOn: $isEmoji)
                .onChange(of: isEmoji) { isEmoji in
                    guard ProManager.default.isPro else {
                        isPaywallPresented = true
                        self.isEmoji = false
                        return
                    }
                    if isEmoji {
                        ui.iconType = .emoji
                    } else {
                        ui.iconType = .text
                    }
                }
        }
    }
}

#Preview {
    SettingsAppearanceSection(
        isPaywallPresented: Binding<Bool>.constant(false),
        isDarkModePresented: Binding<Bool>.constant(false),
        isLandspaceModePresented: Binding<Bool>.constant(false),
        isContentsModePresented: Binding<Bool>.constant(false),
        isColorsPresented: Binding<Bool>.constant(false),
        isAppIconPresented: Binding<Bool>.constant(false)
    )
}
