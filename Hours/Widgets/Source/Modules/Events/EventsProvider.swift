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

    var spacing: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        /// 中号小组件使用高计算事件块大小
        return max(8, (displaySize.height - 32 - dimension * row) / (row - 1))
    }

    var dimension: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        /// 小组件宽度 - 边距 32 - 分类宽度 - 分类与事件距离 - 2 个间距（3 列）* 8
        let maxWidth = floor((displaySize.width - 32 - categoryWidth - 8 - 16) / 3)
        /// 小组件高 - 边距 16 - 间距
        /// 边距正常是 32，由于中号小组件太小，所以这里边距减 16
        let maxHeight = floor((displaySize.height - 16 - (row - 1) * 8) / 2)
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
    var date: Date = .now

    var category: QuickCategoryEntity

    var timingEntities: [TimingEntity] = []

    public let family: WidgetFamily
    public let isPreview: Bool
    public let displaySize: CGSize

    var selection: CategoryEntity? { category.selection }
    var categories: [CategoryEntity]? { category.categories }

    init(context: TimelineProviderContext, categories: [CategoryEntity]) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize

        self.category = QuickCategoryEntity(context: context, categories: categories)
    }

    init(categories: [CategoryEntity]) {
        self.family = .systemLarge
        self.isPreview = true
        self.displaySize = CGSize(width: 100, height: 200)

        self.category = QuickCategoryEntity(categories: categories)
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
            let categories = await AppRealm.shared.getAllUnarchivedCategories()
                .filter { !$0.events.isEmpty }
            var timelineEntry = QuickTimelineEntry(context: context, categories: categories)
            if let entities = Storage.default.currentTimingEntities {
                timelineEntry.timingEntities = entities
            }

            let timeline = Timeline(
                entries: [timelineEntry],
                policy: .after(Date.now.addingTimeInterval(6 * 3600))
            )
            completion(timeline)
        }
    }
}
