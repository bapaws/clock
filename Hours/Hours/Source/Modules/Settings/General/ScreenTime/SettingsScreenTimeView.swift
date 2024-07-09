//
//  SettingsScreenTimeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import HoursShare
import SwiftUI
import SwiftUIX

struct SettingsScreenTimeView: View {
    @State private var isGuidePresented: Bool = false

    @State private var isAutoMergeAdjacentRecords = false

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
                SettingsNavigateCell(title: L10n.autoRecordSetupGuide) {
                    isGuidePresented = true
                }

                SettingsStepperCell(
                    title: L10n.minimumRecordedTime + " (s)",
                    value: app.$minimumRecordedScreenTime,
                    minimumValue: 0,
                    maximumValue: 300,
                    stepValue: 5
                )

                SettingsSection(title: L10n.adjacentRecords) {
                    SettingsToggleCell(title: L10n.autoMergeAdjacentRecords, isOn: app.$isAutoMergeAdjacentRecords.animation())

                    if app.isAutoMergeAdjacentRecords {
                        SettingsStepperCell(
                            title: L10n.interval + " (s)",
                            value: app.$autoMergeAdjacentRecordsInterval,
                            minimumValue: 0,
                            maximumValue: 300,
                            stepValue: 30
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(L10n.appScreenTime)
            .sheet(isPresented: $isGuidePresented) {
                SafariView(url: URL(string: "https://zytllepnl6.feishu.cn/docx/PFtQdUY04og6rbxvbsHciiHNnZd")!)
            }
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
    SettingsScreenTimeView()
}
