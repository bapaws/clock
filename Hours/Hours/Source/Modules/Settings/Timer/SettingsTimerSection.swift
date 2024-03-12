//
//  SettingsTimerSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/25.
//

import ClockShare
import SwiftUI

struct SettingsTimerSection: View {
    @EnvironmentObject var timer: TimerManager
    @State var isShowed: Bool = TimerManager.shared.hourStyle != .none

    var body: some View {
        SettingsToggleCell(title: R.string.localizable.showHour(), isOn: $isShowed)
            .onChange(of: isShowed) { isShowed in
                timer.hourStyle = isShowed ? .big : .none
            }
            .padding(.horizontal)
    }
}

#Preview {
    SettingsTimerSection()
}
