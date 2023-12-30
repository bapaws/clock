//
//  SettingsColorStyleView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/30.
//

import SwiftUI

struct SettingsColorStyleView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(
            title: ColorType.title,
            items: ColorType.allCases.map { mode in
                SettingsItem(type: .check(mode.value, ui.colorType == mode)) {
                    ui.colorType = mode
                    isPresented = false
                }
            }
        )
    }
}

#Preview {
    SettingsColorStyleView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
