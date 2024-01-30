//
//  SettingsClockSection.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/27.
//

import ClockShare
import SwiftUI

struct SettingsClockSection: View {
    @Binding var isPaywallPresented: Bool
    @Binding var isTimeFormatPresented: Bool

    @EnvironmentObject var clock: ClockManager

    @State var isShowed: Bool = ClockManager.shared.secondStyle != .none

    var body: some View {
        SettingsSection(title: R.string.localizable.clock()) {
            SettingsNavigateCell(title: R.string.localizable.timeFormat(), value: "\(clock.timeFormat.rawValue)") {
                isTimeFormatPresented = true
            }
            SettingsToggleCell(title: R.string.localizable.showSecond(), isOn: $isShowed)
                .onChange(of: isShowed) { isShowed in
                    clock.secondStyle = isShowed ? .small : .none
                }
        }
    }
}

#Preview {
    SettingsClockSection(
        isPaywallPresented: Binding<Bool>.constant(false),
        isTimeFormatPresented: Binding<Bool>.constant(false)
    )
    .environmentObject(ClockManager.shared)
}
