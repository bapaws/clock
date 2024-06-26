//
//  SettingsSoundTypeView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/3.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct SettingsSoundTypeView: View {
    @Binding var isPresented: Bool

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.backgroundSound()) {
            ForEach(SoundType.allCases, id: \.self) { type in
                SettingsCheckCell(title: type.value, isChecked: DigitalAppManager.shared.soundType == type) {
                    DigitalAppManager.shared.soundType = type
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsSoundTypeView(isPresented: Binding<Bool>.constant(true))
}
