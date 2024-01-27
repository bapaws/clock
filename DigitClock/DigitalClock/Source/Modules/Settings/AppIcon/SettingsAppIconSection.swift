//
//  SettingsAppIconSection.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/25.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct SettingsAppIconSection: View {
    @Binding var isAppIconPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.icon()) {
            SettingsNavigateCell(title: AppIconType.title) {
                isAppIconPresented = true
            }
        }
    }
}

#Preview {
    SettingsAppIconSection(isAppIconPresented: Binding<Bool>.constant(true))
}
