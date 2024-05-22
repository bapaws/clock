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
                SettingsNavigateCell(title: R.string.localizable.autoRecordSetupGuide()) {
                    isGuidePresented = true
                }

                SettingsStepperCell(
                    title: R.string.localizable.minimumRecordedTime() + " (s)",
                    value: app.$minimumRecordedScreenTime,
                    minimumValue: 0,
                    maximumValue: 300,
                    stepValue: 5
                )

                SettingsSection(title: R.string.localizable.adjacentRecords()) {
                    SettingsToggleCell(title: R.string.localizable.autoMergeAdjacentRecords(), isOn: app.$isAutoMergeAdjacentRecords.animation())

                    if app.isAutoMergeAdjacentRecords {
                        SettingsStepperCell(
                            title: R.string.localizable.interval() + " (s)",
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
            .navigationTitle(R.string.localizable.appScreenTime())
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
