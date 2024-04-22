//
//  TimeRecordClockWidget.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/4/2.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import WidgetKit

struct TimeRecordClockWidget: Widget {
    var secondStyle: DigitStyle = .none

    var kind: String { "TimeRecordClockWidgetWidget" }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            TimeRecordClockEntryView(entry: entry, secondStyle: secondStyle)
                .environmentObject(UIManager.shared)
                .ifLet(UIManager.shared.darkMode.raw) {
                    $0.environment(\.colorScheme, $1)
                }
                .onAppear {
                    ProManager.default.refresh()
                    UIManager.shared.setupColors()
                }
        }
        .supportedFamilies([.systemSmall])
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(R.string.localizable.timeRecord())
    }
}
