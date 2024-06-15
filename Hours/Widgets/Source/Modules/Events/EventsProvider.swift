//
//  EventsProvider.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import Foundation
import HoursShare
import RealmSwift
import WidgetKit

struct QuickCategoryEntity {
    public let family: WidgetFamily
    public let isPreview: Bool
    public let displaySize: CGSize

    let selection: CategoryEntity?
    let categories: [CategoryEntity]

    init(context: TimelineProviderContext, categories: [CategoryEntity]) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize

        var categoryID: String?
        switch family {
        case .systemMedium:
            self.categories = categories.count >= 4 ? Array(categories[0 ..< 4]) : categories
            categoryID = Storage.default.mediumWidgetSelectedCategoryID
        case .systemLarge:
            self.categories = categories.count >= 9 ? Array(categories[0 ..< 9]) : categories
            categoryID = Storage.default.largeWidgetSelectedCategoryID
        default:
            fatalError("Not support")
        }

        if let categoryID {
            self.selection = categories.first { $0.id == categoryID }
        } else {
            self.selection = categories.first
        }
    }

    init(categories: [CategoryEntity]) {
        self.family = .systemLarge
        self.isPreview = true
        self.displaySize = CGSize(width: 100, height: 200)

        self.categories = categories.count >= 9 ? Array(categories[0 ..< 9]) : categories

        self.selection = categories.first
    }

    var maxEventCount: Int {
        switch family {
        case .systemMedium:
            return 6
        case .systemLarge:
            return 12
        default:
            fatalError("Not support")
        }
    }

    var maxCategoryCount: Int {
        switch family {
        case .systemMedium:
            4
        case .systemLarge:
            9
        default:
            fatalError("Not support")
        }
    }

    var categoryWidth: CGFloat {
        return 80
    }

    var padding: CGFloat {
        switch family {
        case .systemMedium:
            5
        case .systemLarge:
            6
        default:
            fatalError("Not support")
        }
    }

    var dimension: CGFloat {
        let maxWidth = floor((displaySize.width - 32 - categoryWidth - 8 - 1 - 8 - 16) / 3)
        let maxHeight = floor((displaySize.height - 24 - 8) / 2)
        return min(maxWidth, maxHeight)
    }

    var kind: String {
        switch family {
        case .systemMedium:
            WidgetsKind.Events.medium
        case .systemLarge:
            WidgetsKind.Events.large
        default:
            fatalError("Not support")
        }
    }

    var widgetURL: URL? {
        switch family {
        case .systemMedium:
            URL(string: WidgetsKind.Events.selectCategoryPath + "?kind=" + WidgetsKind.Events.medium)
        case .systemLarge:
            URL(string: WidgetsKind.Events.selectCategoryPath + "?kind=" + WidgetsKind.Events.large)
        default:
            nil
        }
    }
}

struct QuickTimelineEntry: TimelineEntry {
    var date: Date { timing?.date ?? .now }

    var category: QuickCategoryEntity?

    var timing: TimingEntity?

    public let family: WidgetFamily
    public let isPreview: Bool
    public let displaySize: CGSize

    var selection: CategoryEntity? { category?.selection }
    var categories: [CategoryEntity]? { category?.categories }

    init(context: TimelineProviderContext, categories: [CategoryEntity]) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize

        self.category = QuickCategoryEntity(context: context, categories: categories)
    }

    init(context: TimelineProviderContext, timing: TimingEntity) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize

        self.timing = timing
    }

    init(categories: [CategoryEntity]) {
        self.family = .systemLarge
        self.isPreview = true
        self.displaySize = CGSize(width: 100, height: 200)

        self.category = QuickCategoryEntity(categories: categories)
    }

    init(context: TimelineProviderContext) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize
    }
}

struct EventsProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuickTimelineEntry {
        QuickTimelineEntry(context: context, categories: CategoryEntity.defaults)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuickTimelineEntry) -> ()) {
        let entry = QuickTimelineEntry(context: context, categories: CategoryEntity.defaults)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickTimelineEntry>) -> ()) {
        Task {
            try? await AppRealm.shared.setup()

            var timelineEntry = QuickTimelineEntry(context: context)

            if let entity = Storage.default.currentTimingEntity {
                timelineEntry.timing = entity
            }

            let categories = await AppRealm.shared.getAllUnarchivedCategories()
            timelineEntry.category = QuickCategoryEntity(context: context, categories: categories)

            let timeline = Timeline(
                entries: [timelineEntry],
                policy: .after(Date.now.addingTimeInterval(6 * 3600))
            )
            completion(timeline)
        }
    }
}
