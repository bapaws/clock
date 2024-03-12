//
//  SettingsLandspaceModeView.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsLandspaceModeView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var ui: UIManager

    var body: some View {
        SettingsSection(title: LandspaceMode.title) {
            ForEach(LandspaceMode.allCases, id: \.self) { mode in
                SettingsCheckCell(title: mode.value, isChecked: ui.landspaceMode == mode) {
                    ui.landspaceMode = mode
                    isPresented = false
                }
            }
        }
        .background(UIManager.shared.background)
    }
}

#Preview {
    SettingsLandspaceModeView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(UIManager.shared)
}
