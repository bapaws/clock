//
//  SettingsSoundSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/2.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsSoundSection: View {
    @State var isMute: Bool = AppManager.shared.isMute

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: R.string.localizable.sound()) {
            SettingsToggleCell(title: R.string.localizable.mute(), isOn: $isMute)
                .onChange(of: isMute) { isMute in
                    AppManager.shared.isMute = isMute
                }
        }
    }
}

#Preview {
    SettingsSoundSection()
}
