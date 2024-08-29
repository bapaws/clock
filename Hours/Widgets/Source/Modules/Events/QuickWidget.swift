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

@available(iOSApplicationExtension 17.0, *)
struct QuickWidget: Widget {
    let kind: String = WidgetsKind.Quick.large

    let ui = UIManager.shared

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: QuickConfigurationIntent.self,
            provider: QuickProvider()
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
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// @available(iOS 17.0, *)
// #Preview(as: .systemLarge) {
//    QuickWidget()
// } timeline: {
//    EventsProvider.Entry(categories: CategoryEntity.random(count: 10))
// }
