//
//  SettingsiCloudView.swift
//  Hours
//
//  Created by 张敏超 on 2024/9/28.
//

import HoursShare
import SwiftUI
import SwiftUIX

struct SettingsiCloudView: View {
    @State private var isICloudSync = AppManager.shared.isICloudSync

    var autoMergeAdjacentRecordsInterval: Binding<Double> {
        Binding(
            get: { floor(app.autoMergeAdjacentRecordsInterval / 60) },
            set: { app.autoMergeAdjacentRecordsInterval = $0 * 60 }
        )
    }

    @EnvironmentObject var app: AppManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SettingsToggleCell(title: L10n.iCloud, tag: L10n.limitedTimeFree, isOn: $isICloudSync)
                    .onChange(of: isICloudSync) { newValue in
                        AppManager.shared.isICloudSync = newValue
                        if newValue {
                            Task { await AppRealm.shared.setupSyncCloud() }
                        }
                    }

                SettingsSection(title: L10n.manual) {
                    SettingsNavigateCell(title: L10n.pushLocalData) {
                        Task { await AppRealm.shared.pushAll() }
                    }
                    SettingsNavigateCell(title: L10n.getLatestData) {
                        Task { await AppRealm.shared.pullAll() }
                    }
                }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(L10n.iCloud)
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
    SettingsiCloudView()
}
