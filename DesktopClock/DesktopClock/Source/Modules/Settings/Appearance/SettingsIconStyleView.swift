//
//  SettingsIconStyleView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import SwiftUI

struct SettingsIconStyleView: View {
    @Binding var isPresented: Bool
    @Binding var isPaywallPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: IconType.title) {
            ForEach(IconType.allCases, id: \.self) { mode in
                SettingsCheckCell(title: mode.value, isPro: mode.isPro, isChecked: ui.iconType == mode) {
                    if mode.isPro, !ProManager.default.pro {
                        isPaywallPresented = true
                    } else {
                        ui.iconType = mode
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsIconStyleView(isPresented: Binding<Bool>.constant(false), isPaywallPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
