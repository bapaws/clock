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

//@available(iOSApplicationExtension 17.0, *)
//struct EventsLargeWidgetEntryView: View {
//    var entry: EventsProvider.Entry
//
//    var body: some View {
//        QuickCategoryEntryView(entry: category)
//    }
//}

@available(iOSApplicationExtension 17.0, *)
struct EventsLargeWidget: Widget {
    let kind: String = WidgetsKind.Events.large

    let ui = UIManager.shared

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventsProvider()) { entry in
            QuickCategoryEntryView(entry: entry)
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

@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    EventsLargeWidget()
} timeline: {
    EventsProvider.Entry(categories: CategoryEntity.defaults)
}
