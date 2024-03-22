//
//  SettingsTimingModeSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsTimingModeSection: View {
    @Environment(\.dismiss) var dismiss

    var app: AppManager { AppManager.shared }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ForEach(TimingMode.allCases, id: \.self) { mode in
                    SettingsCheckCell(icon: mode.icon, title: mode.value, isChecked: app.timingMode == mode) {
                        app.timingMode = mode
                        dismiss()
                    }
                }
                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(R.string.localizable.timingMode())
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
    SettingsTimingModeSection()
}
