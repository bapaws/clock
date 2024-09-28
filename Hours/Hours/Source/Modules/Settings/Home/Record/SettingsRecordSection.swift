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
    @State private var isSyncRecordsToCalendar = AppManager.shared.calendarAccessGranted
    @State private var isAppScreenTimePresented: Bool = false
    @State private var isiCloudPresented: Bool = false

    @EnvironmentObject var app: AppManager

    var body: some View {
        SettingsSection(title: L10n.records) {
            SettingsNavigateCell(title: L10n.appScreenTime, tag: newTagTitle) {
                isAppScreenTimePresented.toggle()
            }

            if app.isHealthAvailable {
                SettingsNavigateCell(title: L10n.health, tag: newTagTitle) {
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

            SettingsToggleCell(title: L10n.syncRecordsToCalendar, tag: newTagTitle, isOn: $isSyncRecordsToCalendar)
                .onChange(of: isSyncRecordsToCalendar) { _ in
                    let status = app.calendarAuthorizationStatus
                    // 请求权限
                    app.requestCalendarAccess { granted in
                        self.isSyncRecordsToCalendar = granted

                        if status == .notDetermined { return }
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL)
                    }
                }

            SettingsNavigateCell(title: L10n.iCloud, tag: L10n.limitedTimeFree) {
                isiCloudPresented.toggle()
            }
        }
        .sheet(isPresented: $isiCloudPresented) {
            SettingsiCloudView()
        }
        .sheet(isPresented: $isAppScreenTimePresented) {
            SettingsScreenTimeView()
        }
    }
}

#Preview {
    SettingsRecordSection(isPaywallPresented: .constant(false))
}
