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

extension WidgetFamily {
    var quickMaxCategoryCount: Int {
        switch self {
        case .systemMedium: 4
        case .systemLarge: 9
        default: fatalError("Not support")
        }
    }

    var quickMaxEventCount: Int {
        switch self {
        case .systemMedium: 6
        case .systemLarge: 12
        default: fatalError("Not support")
        }
    }
}

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

    var maxEventCount: Int { family.quickMaxEventCount }
    var maxCategoryCount: Int { family.quickMaxCategoryCount }

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

    var categoryItemHeight: CGFloat {
        floor((displaySize.height - 32) / CGFloat(maxCategoryCount))
    }

    var categoryItemSize: CGSize {
        CGSize(width: 80, height: floor((displaySize.height - 32) / CGFloat(maxCategoryCount)))
    }

    var eventSpacing: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        /// 中号小组件使用高计算事件块大小
        return max(8, (displaySize.height - 32 - dimension * row) / (row - 1))
    }

    var dimension: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        /// 小组件宽度 - 边距 32 - 分类宽度 - 分类与事件距离 - 2 个间距（3 列）* 8
        let maxWidth = floor((displaySize.width - 32 - categoryItemSize.width - 8 - 16) / 3)
        /// 小组件高 - 边距 16 - 间距
        /// 边距正常是 32，由于中号小组件太小，所以这里边距减 16
        let maxHeight = floor((displaySize.height - 16 - (row - 1) * 8) / 2)
        return min(maxWidth, maxHeight)
    }

    var kind: String {
        switch family {
        case .systemMedium:
            WidgetsKind.Quick.medium
        case .systemLarge:
            WidgetsKind.Quick.large
        default:
            fatalError("Not support")
        }
    }

    var widgetURL: URL? {
        switch family {
        case .systemMedium:
            URL(string: WidgetsKind.Quick.selectCategoryPath + "?kind=" + WidgetsKind.Quick.medium)
        case .systemLarge:
            URL(string: WidgetsKind.Quick.selectCategoryPath + "?kind=" + WidgetsKind.Quick.large)
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

@available(iOSApplicationExtension 17.0, *)
struct QuickProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> QuickTimelineEntry {
        QuickTimelineEntry(context: context, categories: CategoryEntity.defaults)
    }

    func snapshot(for configuration: QuickConfigurationIntent, in context: Context) async -> QuickTimelineEntry {
        return QuickTimelineEntry(context: context, categories: CategoryEntity.defaults)
    }

    func timeline(for configuration: QuickConfigurationIntent, in context: Context) async -> Timeline<QuickTimelineEntry> {
        var categories: [CategoryEntity]
        if configuration.categories.isEmpty {
            categories = await AppRealm.shared.getAllUnarchivedCategories()
                .filter { !$0.events.isEmpty }
                .suffix(context.family.quickMaxCategoryCount)
        } else {
            categories = []
            for category in configuration.categories {
                if let id = try? ObjectId(string: category.id),
                   let entity = await AppRealm.shared.getCategory(by: id)
                {
                    categories.append(entity)
                }
            }
        }
        var timelineEntry = QuickTimelineEntry(context: context, categories: categories)
        if let entities = Storage.default.currentTimingEntities {
            timelineEntry.timingEntities = entities
        }

        return Timeline(
            entries: [timelineEntry],
            policy: .after(Date.now.addingTimeInterval(6 * 3600))
        )
    }
}
