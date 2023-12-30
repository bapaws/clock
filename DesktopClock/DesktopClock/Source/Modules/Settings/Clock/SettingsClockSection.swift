//
//  SettingsClockSection.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsClockSection: View {
    @Binding var isPaywallPresented: Bool
    @Binding var isTimeFormatPresented: Bool

    @EnvironmentObject var clock: ClockManager
    
    var body: some View {
        SettingsSection(
            title: R.string.localizable.clock(),
            items: [
                SettingsItem(type: .popup(R.string.localizable.timeFormat(), "\(clock.timeFormat.rawValue)"), action: {
                    isTimeFormatPresented = true
                }),
                SettingsItem(type: .toggle(R.string.localizable.showSecond(), clock.secondStyle != .none), action: {
                    if clock.secondStyle == .none {
                        clock.secondStyle = .small
                    } else {
                        clock.secondStyle = .none
                    }
                }),
            ]
        )
    }
}

#Preview {
    SettingsClockSection(
        isPaywallPresented: Binding<Bool>.constant(false),
        isTimeFormatPresented: Binding<Bool>.constant(false)
    )
    .environmentObject(ClockManager.shared)
}
