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
    @Binding var isPaywallPresented: Bool
    @State private var isTimerPresented: Bool = false
    @State private var isSyncRecordsToCalendar = AppManager.shared.isSyncRecordsToCalendar

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: R.string.localizable.records()) {
            SettingsNavigateCell(title: R.string.localizable.timer()) {
                isTimerPresented = true
            }

            // Pro 功能
            SettingsToggleCell(title: R.string.localizable.syncRecordsToCalendar(), isPro: true, isOn: $isSyncRecordsToCalendar)
                .onChange(of: isSyncRecordsToCalendar) { isSyncRecordsToCalendar in
                    // 先判断是否符合 Pro 的条件
                    if !ProManager.default.isPro {
                        isPaywallPresented = true
                        self.isSyncRecordsToCalendar = false
                        return
                    }
                    if !isSyncRecordsToCalendar {
                        AppManager.shared.isSyncRecordsToCalendar = false
                        return
                    }
                    // 请求权限
                    app.requestAccess { granted in
                        self.isSyncRecordsToCalendar = granted
                        AppManager.shared.isSyncRecordsToCalendar = granted

                        guard !granted else { return }
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL)
                    }
                }
        }
        .sheet(isPresented: $isTimerPresented) {
            SettingsTimerSection()
                .environmentObject(TimerManager.shared)
        }
    }
}

#Preview {
    SettingsRecordSection(isPaywallPresented: .constant(false))
}
