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
    @State private var isSyncRecordsToCalendar = AppManager.shared.calendarAccessGranted
    @State private var isAppScreenTimePresented: Bool = false

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: L10n.records) {
            SettingsNavigateCell(title: L10n.timer) {
                isTimerPresented.toggle()
            }

            SettingsToggleCell(title: L10n.syncRecordsToCalendar, isNew: true, isOn: $isSyncRecordsToCalendar)
                .onChange(of: isSyncRecordsToCalendar) { _ in
                    // 请求权限
                    app.requestCalendarAccess { granted in
                        self.isSyncRecordsToCalendar = granted

                        guard !granted else { return }
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL)
                    }
                }

            SettingsNavigateCell(title: L10n.appScreenTime, isNew: true) {
                isAppScreenTimePresented.toggle()
            }

            if app.isHealthAvailable {
                SettingsNavigateCell(title: L10n.health, isNew: true) {
                    app.getRequestHealthStatus { [weak app] shouldRequest in
                        if shouldRequest {
                            app?.requestHealthAccess()
                        } else {
                            DispatchQueue.main.async {
                                app?.openHealthSettings()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isTimerPresented) {
            SettingsTimerSection()
                .environmentObject(TimerManager.shared)
        }
        .sheet(isPresented: $isAppScreenTimePresented) {
            SettingsScreenTimeView()
        }
    }
}

#Preview {
    SettingsRecordSection(isPaywallPresented: .constant(false))
}
