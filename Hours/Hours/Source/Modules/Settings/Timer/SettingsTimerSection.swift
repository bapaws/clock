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
                SettingsToggleCell(title: R.string.localizable.showHour(), isOn: isShowed)

                SettingsStepperCell(title: R.string.localizable.minimumRecordedTime() + " (s)", value: app.$minimumRecordedTime, minimumValue: 0, maximumValue: 300, stepValue: 30)

                SettingsStepperCell(title: R.string.localizable.maximumRecordedTime() + " (h)", value: maximumRecordedTime, minimumValue: 1, maximumValue: 24, stepValue: 1)

                Spacer()
            }
            .padding()
            .background(ui.background)
            .navigationTitle(R.string.localizable.timer())
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
