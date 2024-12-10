//
//  SettingsTimerSection.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/25.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsTimerSection: View {
    @EnvironmentObject var timer: TimerManager
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var app: AppManager

    @State var isMute: Bool = AppManager.shared.isMute
    @State var isMaximumRecordedTime: Bool = true

    var isShowed: Binding<Bool> {
        Binding(get: { timer.hourStyle == .big }, set: { newValue in timer.hourStyle = newValue ? .big : .none })
    }

    var maximumRecordedTime: Binding<Double> {
        Binding(
            get: { floor(app.maximumRecordedTime / 60 / 60) },
            set: { app.maximumRecordedTime = $0 * 60 * 60 }
        )
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                SettingsToggleCell(title: L10n.showHour, isOn: isShowed)

                SettingsStepperCell(title: L10n.minimumRecordedTime + " (s)", value: app.$minimumRecordedTime, minimumValue: 0, maximumValue: 300, stepValue: 30)

                SettingsToggleCell(title: L10n.limitMaximumDuration, isOn: app.$limitMaximumDuration.animation())
                if app.limitMaximumDuration {
                    SettingsStepperCell(title: L10n.maximumRecordedTime + " (h)", value: maximumRecordedTime, minimumValue: 1, maximumValue: nil, stepValue: 1)
                }

                SettingsSection(title: L10n.sound) {
                    SettingsToggleCell(title: L10n.mute, isOn: $isMute)
                        .onChange(of: isMute) { isMute in
                            AppManager.shared.isMute = isMute
                        }
                }

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(L10n.timer)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .background(ui.background)
    }
}

#Preview {
    SettingsTimerSection()
}
