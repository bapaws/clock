//
//  SettingsScreenTimeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import HoursShare
import SwiftUI

struct SettingsScreenTimeView: View {
    @State private var path: NavigationPath = .init()
    @State private var isGuidePresented: Bool = false

    @State private var isAutoMergeAdjacentRecords = false

    @EnvironmentObject var app: AppManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                SettingsNavigateCell(title: R.string.localizable.autoRecordSetupGuide()) {
                    isGuidePresented = true
                }

                SettingsStepperCell(title: R.string.localizable.minimumRecordedTime() + " (s)", value: app.$minimumRecordedScreenTime, minimumValue: 0, maximumValue: 300, stepValue: 5)

                SettingsSection(title: R.string.localizable.adjacentRecords()) {
                    SettingsToggleCell(title: R.string.localizable.autoMergeAdjacentRecords(), isOn: app.$isAutoMergeAdjacentRecords)

                    if app.isAutoMergeAdjacentRecords {
                        SettingsStepperCell(title: R.string.localizable.interval() + " (m)", value: app.$autoMergeAdjacentRecordsInterval, minimumValue: 0, maximumValue: 10, stepValue: 2)
                    }
                }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(R.string.localizable.appScreenTime())
            .navigationDestination(isPresented: $isGuidePresented) {
                Text("")
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
