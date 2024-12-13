//
//  EventsView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOS 17.0, *)
struct QuickMediumWidget: Widget {
    let kind: String = WidgetsKind.Quick.medium

    let ui = UIManager.shared

    let provider = QuickAppIntentProvider()

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: QuickMediumConfigurationIntent.self,
            provider: provider
        ) { entry in
            QuickEntryView(entry: entry)
                .environmentObject(ui)
                .containerBackground(ui.background)
                .onAppear {
                    UIManager.shared.setupColors()
                }
        }
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(L10n.quickTiming)
        .supportedFamilies([.systemMedium])
    }
}

// MARK: -

@available(iOS 17.0, *)
struct QuickLargeWidget: Widget {
    let kind: String = WidgetsKind.Quick.large

    let ui = UIManager.shared

    let provider = QuickLargeAppIntentProvider()

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: QuickLargeConfigurationIntent.self,
            provider: provider
        ) { entry in
            QuickEntryView(entry: entry)
                .environmentObject(ui)
                .containerBackground(ui.background)
                .onAppear {
                    UIManager.shared.setupColors()
                }
        }
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(L10n.quickTiming)
        .supportedFamilies([.systemLarge])
    }
}

// @available(iOS 17.0, *)
// #Preview(as: .systemLarge) {
//    QuickWidget()
// } timeline: {
//    EventsProvider.Entry(categories: CategoryEntity.random(count: 10))
// }
