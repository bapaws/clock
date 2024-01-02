//
//  SettingsTimeFormatView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsTimeFormatView: View {
    @Binding var isPresented: Bool

    @EnvironmentObject var clock: ClockManager

    var body: some View {
        SettingsSection(title: R.string.localizable.timeFormat()) {
            ForEach(TimeFormat.allCases, id: \.self) { option in
                SettingsCheckCell(title: "\(option.rawValue)", isChecked: clock.timeFormat == option) {
                    clock.timeFormat = option
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SettingsTimeFormatView(isPresented: Binding<Bool>.constant(false))
        .environmentObject(ClockManager.shared)
}
