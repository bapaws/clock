//
//  SettingsScreenTimeSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/16.
//

import HoursShare
import SwiftUI

struct SettingsScreenTimeSection: View {
    @State private var isAppScreenTimePresented: Bool = false

    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: R.string.localizable.appScreenTime()) {
            SettingsNavigateCell(title: R.string.localizable.appScreenTime()) {
                isAppScreenTimePresented = true
            }
        }
        .background(ui.background)
        .sheet(isPresented: $isAppScreenTimePresented) {
            SettingsScreenTimeView()
        }
    }
}

#Preview {
    SettingsScreenTimeSection()
}
