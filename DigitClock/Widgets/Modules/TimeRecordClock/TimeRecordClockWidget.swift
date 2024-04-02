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
    var colorScheme: ColorScheme = .light

    var kind: String {
        "TimeRecordClockWidgetWidget" + secondStyle.rawValue + "\(colorScheme)"
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            TimeRecordClockEntryView(entry: entry, secondStyle: secondStyle)
                .environmentObject(UIManager.shared)
                .environment(\.colorScheme, colorScheme)
        }
        .supportedFamilies([.systemSmall])
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(R.string.localizable.timeRecord())
    }
}
