//
//  SettingsUIContentsModeView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI

struct SettingsUIContentsModeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(
            title: IconType.title,
            items: IconType.allCases.map { mode in
                SettingsItem(type: .check(mode.value, ui.iconType == mode)) {
                    ui.iconType = mode
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsUIContentsModeView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
