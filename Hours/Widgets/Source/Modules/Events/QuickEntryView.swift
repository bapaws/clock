//
//  QuickEntryView.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX
import WidgetKit

@available(iOSApplicationExtension 17.0, *)
struct QuickEntryView: View {
    var entry: QuickTimelineEntry
    var quickCategory: QuickCategoryEntity {
        entry.category
    }

    private let categoryItemSize: CGSize
    private let spacing: CGFloat
    private let dimension: CGFloat
    init(entry: QuickTimelineEntry) {
        self.entry = entry
        self.categoryItemSize = entry.category.categoryItemSize
        self.spacing = entry.category.eventSpacing
        self.dimension = entry.category.dimension
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0 ..< quickCategory.categories.count, id: \.self) { index in
                    let category = quickCategory.categories[index]
                    let intent = QuickSelectCategoryAppIntent(categoryID: category.id, family: quickCategory.family)
                    Button(intent: intent) {
                        let isSelected = quickCategory.selection?.id == category.id

                        HStack(spacing: 0) {
                            Text(category.title)
                                .fontWeight(isSelected ? .bold : .regular)
                                .padding(.vertical, quickCategory.eventPadding)
                            Spacer()
                            if isSelected {
                                Capsule()
                                    .fill(category.primary)
                                    .frame(width: 2, height: 18)
                            }
                        }
                        .widgetAccentable(isSelected)
                        .font(isSelected ? .footnote : .caption2)
                        .foregroundStyle(isSelected ? category.primary : ui.secondaryLabel)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .frame(categoryItemSize)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                // 只有少于最大数量时，才需要填充空间
                if quickCategory.categories.count < quickCategory.maxCategoryCount {
                    Spacer()
                }
            }
            .width(categoryItemSize.width)

            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: spacing) {
                if let events = (quickCategory.selection ?? quickCategory.categories.first)?.events {
                    ForEach(0 ..< min(quickCategory.maxEventCount, events.count), id: \.self) { index in
                        let event = events[index]
                        if let entity = entry.timingEntities.first(where: { $0.id == event.id }) {
                            QuickTimingItemView(entity: entity, dimensions: dimension)
                        } else {
                            QuickEventItemView(
                                event: event,
                                padding: quickCategory.eventPadding,
                                dimension: dimension
                            )
                        }
                    }
                }
            }
            .width(entry.displaySize.width - entry.horizontalPadding * 2 - categoryItemSize.width - 8)
        }
        .padding(.vertical, entry.verticalPadding)
        .padding(.horizontal, entry.horizontalPadding)
    }
}

#Preview {
    let categories = CategoryEntity.random(count: 9)
    let entity = QuickTimelineEntry(categories: categories)
    if #available(iOSApplicationExtension 17.0, *) {
        return QuickEntryView(entry: entity)
    } else {
        return EmptyView()
    }
}
