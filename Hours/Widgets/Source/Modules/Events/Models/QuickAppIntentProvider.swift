//
//  QuickProvider.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import Foundation
import HoursShare
import RealmSwift
import WidgetKit

@available(iOS 17.0, *)
struct QuickAppIntentProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> QuickTimelineEntry {
        let defaults = CategoryEntity.defaults.prefix(context.family.quickMaxCategoryCount)

        var entry = QuickTimelineEntry(context: context)
        var categories = defaults.map { QuickCategoryEntity(entity: $0) }
        if let events = defaults.first?.events {
            categories[0].events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        entry.widget = QuickWidgetEntity(categories: categories)
        return entry
    }

    func snapshot(for configuration: QuickMediumConfigurationIntent, in context: Context) async -> QuickTimelineEntry {
        let defaults = CategoryEntity.defaults.prefix(context.family.quickMaxCategoryCount)

        var entry = QuickTimelineEntry(context: context)
        var categories = defaults.map { QuickCategoryEntity(entity: $0) }
        if let events = defaults.first?.events {
            categories[0].events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        entry.widget = QuickWidgetEntity(categories: categories)
        return entry
    }

    func timeline(for configuration: QuickMediumConfigurationIntent, in context: Context) async -> Timeline<QuickTimelineEntry> {
        var entry = QuickTimelineEntry(context: context)

        let quickMediumWidgets = Storage.default.quickMediumWidgets
        if let selectedID = configuration.widget?.id, let widget = quickMediumWidgets?.first(where: { $0.id == selectedID }) {
            entry.widget = widget
        } else if let widget = quickMediumWidgets?.first {
            entry.widget = widget
        } else {
            /// Realm 这个坑数据库，打开一个 Realm 的实例，直接把内存从 8MB -> 28MB
            /// 升级情况下，最坏的情况，会导致小组件超过内存直接崩溃
            await AppRealm.shared.setupDefaultWidget()
            await AppRealm.shared.close()

            if let widget = Storage.default.quickMediumWidgets?.first {
                entry.widget = widget
            }
        }

        if let entities = Storage.default.currentTimingEntities {
            entry.timingEntities = entities
        }

        return Timeline(
            entries: [entry],
            policy: .after(Date.now.addingTimeInterval(6 * 3600))
        )
    }
}

// MARK: -

@available(iOS 17.0, *)
struct QuickLargeAppIntentProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> QuickTimelineEntry {
        let defaults = CategoryEntity.defaults.prefix(context.family.quickMaxCategoryCount)

        var entry = QuickTimelineEntry(context: context)
        var categories = defaults.map { QuickCategoryEntity(entity: $0) }
        if let events = defaults.first?.events {
            categories[0].events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        entry.widget = QuickWidgetEntity(categories: categories)
        return entry
    }

    func snapshot(for configuration: QuickLargeConfigurationIntent, in context: Context) async -> QuickTimelineEntry {
        let defaults = CategoryEntity.defaults.prefix(context.family.quickMaxCategoryCount)

        var entry = QuickTimelineEntry(context: context)
        var categories = defaults.map { QuickCategoryEntity(entity: $0) }
        if let events = defaults.first?.events {
            categories[0].events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        entry.widget = QuickWidgetEntity(categories: categories)
        return entry
    }

    func timeline(for configuration: QuickLargeConfigurationIntent, in context: Context) async -> Timeline<QuickTimelineEntry> {
        var entry = QuickTimelineEntry(context: context)

        let quickLargeWidgets = Storage.default.quickLargeWidgets
        if let selectedID = configuration.widget?.id, let widget = quickLargeWidgets?.first(where: { $0.id == selectedID }) {
            entry.widget = widget
        } else if let widget = quickLargeWidgets?.first {
            entry.widget = widget
        } else {
            /// Realm 这个坑数据库，打开一个 Realm 的实例，直接把内存从 8MB -> 28MB
            /// 升级情况下，最坏的情况，会导致小组件超过内存直接崩溃
            await AppRealm.shared.setupDefaultWidget()
            await AppRealm.shared.close()

            if let widget = Storage.default.quickLargeWidgets?.first {
                entry.widget = widget
            }
        }

        if let entities = Storage.default.currentTimingEntities {
            entry.timingEntities = entities
        }

        return Timeline(
            entries: [entry],
            policy: .after(Date.now.addingTimeInterval(6 * 3600))
        )
    }
}
