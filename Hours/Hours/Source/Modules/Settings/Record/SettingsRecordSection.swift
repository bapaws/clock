//
//  SettingsRecordSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsRecordSection: View {
    @State var isTimerPresented: Bool = false

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: R.string.localizable.records()) {
            SettingsNavigateCell(title: R.string.localizable.timer()) {
                isTimerPresented = true
            }
        }
        .sheet(isPresented: $isTimerPresented) {
            SettingsTimerSection()
                .environmentObject(TimerManager.shared)
        }
    }
}

#Preview {
    SettingsRecordSection()
}
