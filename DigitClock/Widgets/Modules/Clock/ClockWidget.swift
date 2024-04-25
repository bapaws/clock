//
//  ClockWidget.swift
//  DesktopClockWidget
//
//  Created by 张敏超 on 2024/1/9.
//

import ClockShare
import DigitalClockShare
import Foundation
import SwiftUI
import WidgetKit

struct ClockSmallWidget: Widget {
    var secondStyle: DigitStyle = .none

    var kind: String {
        "DigitalClockSmallWidget" + secondStyle.rawValue
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockEntryView(entry: entry, secondStyle: secondStyle)
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
        .configurationDisplayName(R.string.localizable.appName())
    }
}

struct ClockMediumWidget: Widget {
    var secondStyle: DigitStyle = .none

    var kind: String {
        "DigitalClockMediumWidget" + secondStyle.rawValue
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockMediumEntryView(entry: entry, secondStyle: secondStyle)
                .environmentObject(UIManager.shared)
                .ifLet(UIManager.shared.darkMode.raw) {
                    $0.environment(\.colorScheme, $1)
                }
                .onAppear {
                    ProManager.default.refresh()
                    UIManager.shared.setupColors()
                }
        }
        .supportedFamilies([.systemMedium])
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(R.string.localizable.appName())
    }
}
