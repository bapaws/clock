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
struct EventsLargeWidgetEntryView: View {
    var entry: EventsProvider.Entry

    var body: some View {
        if let timingEvent = entry.timing {
            if entry.family == .systemMedium {
                QuickTimerView(date: entry.date, event: timingEvent)
            } else {
                ZStack {
                    if let category = entry.category {
                        QuickCategoryEntryView(entry: category, isClickEnabled: false)
                            .blur(radius: 6)
                    }
                    Color.clear
                        .frame(entry.displaySize)
                        .allowsHitTesting(false)
                    QuickTimerView(date: entry.date, event: timingEvent)
                        .frame(width: entry.displaySize.width * 0.9, height: entry.displaySize.width * 0.4)
                        .cornerRadius(20, style: .circular)
                }
            }
        } else if let category = entry.category {
            QuickCategoryEntryView(entry: category)
        }
    }
}

@available(iOSApplicationExtension 17.0, *)
struct EventsLargeWidget: Widget {
    let kind: String = WidgetsKind.Events.large

    let ui = UIManager.shared

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventsProvider()) { entry in
            EventsLargeWidgetEntryView(entry: entry)
                .environmentObject(ui)
                .containerBackground(ui.background)
                .onAppear {
                    UIManager.shared.setupColors()
                }
        }
        .disableContentMarginsIfNeeded()
        .configurationDisplayName(R.string.localizable.quickTiming())
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemLarge) {
    EventsLargeWidget()
} timeline: {
    EventsProvider.Entry(categories: CategoryEntity.defaults)
}
