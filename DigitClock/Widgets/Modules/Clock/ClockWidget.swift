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
    var colorScheme: ColorScheme = .light

    var kind: String {
        "DigitalClockSmallWidget" + secondStyle.rawValue + "\(colorScheme)"
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockEntryView(entry: entry, secondStyle: secondStyle)
                .environmentObject(UIManager.shared)
                .environment(\.colorScheme, colorScheme)
                .onAppear {
                    UIManager.shared.setupColors(scheme: colorScheme)
                }
        }
        .supportedFamilies([.systemSmall])
        .disableContentMarginsIfNeeded()
        .configurationDisplayName("Clock")
        .description("This is an clock widget.")
    }
}

struct ClockMediumWidget: Widget {
    var secondStyle: DigitStyle = .none
    var colorScheme: ColorScheme = .light

    var kind: String {
        "DigitalClockMediumWidget" + secondStyle.rawValue + "\(colorScheme)"
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ClockProvider()) { entry in
            ClockMediumEntryView(entry: entry, secondStyle: secondStyle)
                .environmentObject(UIManager.shared)
                .environment(\.colorScheme, colorScheme)
                .onAppear {
                    UIManager.shared.setupColors(scheme: colorScheme)
                }
        }
        .supportedFamilies([.systemMedium])
        .disableContentMarginsIfNeeded()
        .configurationDisplayName("Clock")
        .description("This is an clock widget.")
    }
}
