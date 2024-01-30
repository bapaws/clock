//
//  SettingsColorsView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/30.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct SettingsColorsView: View {
    @Binding var isPresented: Bool
    @Binding var isPaywallPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: ColorType.title) {
            ForEach(ColorType.allCases, id: \.self) { mode in
                SettingsCheckCell(title: mode.value, isPro: mode.isPro, isChecked: ui.colorType == mode) {
                    if mode.isPro, !ProManager.default.isPro {
                        isPaywallPresented = true
                    } else {
                        ui.colorType = mode
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsColorsView(isPresented: Binding<Bool>.constant(false), isPaywallPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
