//
//  SettingsLandspaceModeView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI

struct SettingsLandspaceModeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(
            title: LandspaceMode.title,
            items: LandspaceMode.allCases.map { mode in
                SettingsItem(type: .check(mode.value, ui.landspaceMode == mode)) {
                    ui.landspaceMode = mode
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsLandspaceModeView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
