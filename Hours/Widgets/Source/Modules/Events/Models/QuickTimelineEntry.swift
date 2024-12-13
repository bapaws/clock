//
//  QuickTimelineEntry.swift
//  Hours
//
//  Created by 张敏超 on 2024/12/9.
//

import ClockShare
import Foundation
import HoursShare
import RealmSwift
import WidgetKit

struct QuickTimelineEntry: TimelineEntry, Equatable {
    var date: Date = .now

    public let family: WidgetFamily
    public let isPreview: Bool
    public let displaySize: CGSize

    var timingEntities: [TimingEntity] = []
    var widget: QuickWidgetEntity?

    init(family: WidgetFamily, isPreview: Bool = true, displaySize: CGSize, timingEntities: [TimingEntity] = [], widget: QuickWidgetEntity?) {
        self.family = family
        self.isPreview = isPreview
        self.displaySize = displaySize
        self.timingEntities = timingEntities
        self.widget = widget
    }

    init(context: TimelineProviderContext) {
        self.family = context.family
        self.isPreview = context.isPreview
        self.displaySize = context.displaySize
    }

    public var categories: [QuickCategoryEntity]? { widget?.categories }
    public var selectedEvents: [QuickEventEntity]? { widget?.selectedEvents }
}

extension QuickTimelineEntry {
    var maxEventCount: Int { family.quickMaxEventCount }
    var maxCategoryCount: Int { family.quickMaxCategoryCount }

    var verticalPadding: CGFloat {
        switch family {
        case .systemMedium: 10
        case .systemLarge: 16
        default: fatalError("Not support")
        }
    }

    var horizontalPadding: CGFloat {
        switch family {
        case .systemMedium: 16
        case .systemLarge: 16
        default: fatalError("Not support")
        }
    }

    var eventPadding: CGFloat {
        switch family {
        case .systemMedium: 4
        case .systemLarge: 6
        default:
            fatalError("Not support")
        }
    }

    var categoryItemHeight: CGFloat {
        floor((displaySize.height - 32) / CGFloat(maxCategoryCount))
    }

    var categoryItemSize: CGSize {
        CGSize(width: 80, height: floor((displaySize.height - verticalPadding * 2) / CGFloat(maxCategoryCount)))
    }

    var eventSpacing: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        switch family {
        case .systemMedium:
            return max(8, (displaySize.height - verticalPadding * 2 - dimension * row) / (row - 1))
        case .systemLarge:
            return max(8, (displaySize.height - verticalPadding * 2 - (dimension + 21) * row) / (row - 1))
        default:
            fatalError("Not support")
        }
        /// 中号小组件使用高计算事件块大小
//        return max(8, (displaySize.height - verticalPadding * 2 - dimension * row) / (row - 1))
    }

    var dimension: CGFloat {
        let row = CGFloat(maxEventCount / 3)
        /// 小组件宽度 - 边距 32 - 分类宽度 - 分类与事件距离 - 2 个间距（3 列）* 8
        let maxWidth = floor((displaySize.width - horizontalPadding * 2 - categoryItemSize.width - 8 - 16) / 3)
        /// 小组件高 - 边距 16 - 间距
        /// 边距正常是 32，由于中号小组件太小，所以这里边距减 16
        let maxHeight = floor((displaySize.height - verticalPadding * 2 - (row - 1) * 8) / 2)
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
