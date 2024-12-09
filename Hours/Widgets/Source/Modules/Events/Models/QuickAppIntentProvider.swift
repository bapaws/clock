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
        entry.categories = defaults.map { QuickCategoryEntity(entity: $0) }
        entry.selection = defaults.first?.id
        if let events = defaults.first?.events {
            entry.events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        return entry
    }

    func snapshot(for configuration: QuickConfigurationIntent, in context: Context) async -> QuickTimelineEntry {
        let defaults = CategoryEntity.defaults.prefix(context.family.quickMaxCategoryCount)

        var entry = QuickTimelineEntry(context: context)
        entry.categories = defaults.map { QuickCategoryEntity(entity: $0) }
        entry.selection = defaults.first?.id
        if let events = defaults.first?.events {
            entry.events = Array(events.map { QuickEventEntity(entity: $0) }.prefix(context.family.quickMaxEventCount))
        }
        return entry
    }

    func timeline(for configuration: QuickConfigurationIntent, in context: Context) async -> Timeline<QuickTimelineEntry> {
        var entry = QuickTimelineEntry(context: context)

        var selectedCategoryID: String?
        switch context.family {
        case .systemMedium:
            selectedCategoryID = Storage.default.mediumWidgetSelectedCategoryID
        case .systemLarge:
            selectedCategoryID = Storage.default.largeWidgetSelectedCategoryID
        default:
            break
        }

        if configuration.categories.isEmpty {
            entry.categories = await AppRealm.shared.getQuickUnarchivedCategories(count: context.family.quickMaxCategoryCount)
        } else {
            var categories = [QuickCategoryEntity]()
            for category in configuration.categories {
                if let id = try? ObjectId(string: category.id), let entity = await AppRealm.shared.getQuickCategory(by: id) {
                    categories.append(entity)
                }
            }
            entry.categories = categories
        }

        if entry.categories.contains(where: { $0.id == selectedCategoryID }) {
            entry.selection = selectedCategoryID
        } else {
            entry.selection = entry.categories.first?.id
        }

        if let selectedCategoryID = entry.selection {
            entry.events = await AppRealm.shared.getQuickEvents(categoryID: selectedCategoryID, maxCount: context.family.quickMaxEventCount)
        }

        await AppRealm.shared.close()

        if let entities = Storage.default.currentTimingEntities {
            entry.timingEntities = entities
        }

        return Timeline(
            entries: [entry],
            policy: .after(Date.now.addingTimeInterval(6 * 3600))
        )
    }
}

// struct QuickProvider: TimelineProvider {
//    func placeholder(in context: Context) -> QuickTimelineEntry {
//        let defaults = CategoryEntity.defaults
//
//        var entry = QuickTimelineEntry(context: context)
//        entry.categories = defaults.map { QuickCategoryEntity(entity: $0) }
//        entry.selection = defaults.first?.id
//        entry.events = defaults.first?.events.map { QuickEventEntity(entity: $0) } ?? []
//        return entry
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping @Sendable (QuickTimelineEntry) -> Void) {
//        let defaults = CategoryEntity.defaults
//
//        var entry = QuickTimelineEntry(context: context)
//        entry.categories = defaults.map { QuickCategoryEntity(entity: $0) }
//        entry.selection = defaults.first?.id
//        entry.events = defaults.first?.events.map { QuickEventEntity(entity: $0) } ?? []
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<QuickTimelineEntry>) -> Void) {
//        Task {
//            var entry = QuickTimelineEntry(context: context)
//
//            var selectedCategoryID: String?
//            switch context.family {
//            case .systemMedium:
//                selectedCategoryID = Storage.default.mediumWidgetSelectedCategoryID
//            case .systemLarge:
//                selectedCategoryID = Storage.default.largeWidgetSelectedCategoryID
//            default:
//                break
//            }
//
//            entry.categories = await AppRealm.shared.getQuickUnarchivedCategories(count: context.family.quickMaxCategoryCount)
//            if entry.categories.contains(where: { $0.id == selectedCategoryID }) {
//                entry.selection = selectedCategoryID
//            } else {
//                entry.selection = entry.categories.first?.id
//            }
//
//            if let selectedCategoryID = entry.selection {
//                entry.events = await AppRealm.shared.getQuickEvents(categoryID: selectedCategoryID, maxCount: context.family.quickMaxEventCount)
//            }
//
//            await AppRealm.shared.close()
//
//            if let entities = Storage.default.currentTimingEntities {
//                entry.timingEntities = entities
//            }
//
//            let timeline = Timeline(
//                entries: [entry],
//                policy: .after(Date.now.addingTimeInterval(6 * 3600))
//            )
//            completion(timeline)
//        }
//    }
// }
