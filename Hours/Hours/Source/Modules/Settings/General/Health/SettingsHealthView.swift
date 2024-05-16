//
//  SettingsHealthView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/16.
//

import HoursShare
import SwiftUI

struct SettingsHealthView: View {
    @EnvironmentObject var app: AppManager
    @Environment(\.dismiss) var dismiss

    @State private var isAutoSyncSleep = AppManager.shared.isAutoSyncSleep
    @State private var isAutoSyncWorkout = AppManager.shared.isAutoSyncWorkout

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SettingsToggleCell(title: R.string.localizable.healthAutoSyncSleep(), isOn: $isAutoSyncSleep)
                    .onChange(of: isAutoSyncSleep) { isAutoSyncSleep in
                        if !isAutoSyncSleep {
                            AppManager.shared.isAutoSyncSleep = false
                            return
                        }
                        app.requestHealthAccess { granted in
                            self.isAutoSyncSleep = granted
                            AppManager.shared.isAutoSyncSleep = granted

                            guard !granted else { return }
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                
                SettingsToggleCell(title: R.string.localizable.healthAutoSyncWorkout(), isOn: $isAutoSyncWorkout)
                    .onChange(of: isAutoSyncWorkout) { isAutoSyncWorkout in
                        if !isAutoSyncWorkout {
                            AppManager.shared.isAutoSyncWorkout = false
                            return
                        }
                        app.requestHealthAccess { granted in
                            self.isAutoSyncWorkout = granted
                            AppManager.shared.isAutoSyncWorkout = granted

                            guard !granted else { return }
                            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(settingsURL)
                        }
                    }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(R.string.localizable.appScreenTime())
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
    SettingsHealthView()
}
