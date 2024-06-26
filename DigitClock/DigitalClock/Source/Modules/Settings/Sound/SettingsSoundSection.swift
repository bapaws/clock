//
//  SettingsSoundSection.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/2.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct SettingsSoundSection: View {
    @Binding var isSoundTypePresented: Bool
    @State var isMute: Bool = DigitalAppManager.shared.isMute

    @EnvironmentObject var app: DigitalAppManager
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.sound()) {
            SettingsToggleCell(title: R.string.localizable.mute(), isOn: $isMute)
                .onChange(of: isMute) { isMute in
                    DigitalAppManager.shared.isMute = isMute
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
