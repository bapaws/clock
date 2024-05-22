//
//  SettingsDarkModeView.swift
//  Hours
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsDarkModeView: View {
    @EnvironmentObject var ui: UIManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(DarkMode.allCases, id: \.self) { mode in
                    SettingsCheckCell(title: mode.value, isChecked: ui.darkMode == mode) {
                        ui.darkMode = mode
                        dismiss()
                    }
                }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(DarkMode.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsDarkModeView()
        .environmentObject(UIManager.shared)
}
