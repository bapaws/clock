//
//  SettingsSoundSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/2.
//

import SwiftUI

struct SettingsSoundSection: View {
    @Binding var isSoundTypePresented: Bool
    @State var isMute: Bool = AppManager.shared.isMute

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: R.string.localizable.sound()) {
            SettingsToggleCell(title: R.string.localizable.mute(), isOn: $isMute)
                .onChange(of: isMute) { isMute in
                    AppManager.shared.isMute = isMute
                }

            SettingsNavigateCell(title: R.string.localizable.backgroundSound(), value: app.soundType.value) {
                isSoundTypePresented = true
            }
        }
    }
}

#Preview {
    SettingsSoundSection(isSoundTypePresented: Binding.constant(false))
}
