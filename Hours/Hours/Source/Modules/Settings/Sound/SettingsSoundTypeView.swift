//
//  SettingsSoundTypeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/3.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsSoundTypeView: View {
    @Binding var isPresented: Bool

    var body: some View {
        SettingsSection(title: R.string.localizable.backgroundSound()) {
            ForEach(SoundType.allCases, id: \.self) { type in
                SettingsCheckCell(title: type.value, isChecked: AppManager.shared.soundType == type) {
                    AppManager.shared.soundType = type
                    isPresented = false
                }
            }
        }
        .background(UIManager.shared.background)
    }
}

#Preview {
    SettingsSoundTypeView(isPresented: Binding<Bool>.constant(true))
}
