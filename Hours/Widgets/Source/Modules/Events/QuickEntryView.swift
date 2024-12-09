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

@available(iOS 17.0, *)
struct QuickEntryView: View {
    let entry: QuickTimelineEntry

    private let categoryItemSize: CGSize
    private let dimension: CGFloat
    init(entry: QuickTimelineEntry) {
        self.entry = entry
        self.categoryItemSize = entry.categoryItemSize
        self.dimension = entry.dimension
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0 ..< entry.categories.count, id: \.self) { index in
                    let category = entry.categories[index]
                    let intent = QuickSelectCategoryAppIntent(categoryID: category.id, family: entry.family)
                    Button(intent: intent) {
                        let isSelected = entry.selection == category.id

                        HStack(spacing: 0) {
                            Text(category.title)
                                .fontWeight(isSelected ? .bold : .regular)
                                .padding(.vertical, entry.eventPadding)
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
                if entry.categories.count < entry.maxCategoryCount {
                    Spacer()
                }
            }
            .width(categoryItemSize.width)

            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: entry.eventSpacing) {
                ForEach(0 ..< min(entry.maxEventCount, entry.events.count), id: \.self) { index in
                    let event = entry.events[index]
                    if let entity = entry.timingEntities.first(where: { $0.id == event.id }) {
                        if entry.family == .systemLarge {
                            QuickLargeTimingItemView(entity: entity, dimensions: dimension)
                        } else {
                            QuickTimingItemView(entity: entity, dimensions: dimension)
                        }
                    } else if entry.family == .systemLarge {
                        QuickLargeEventItemView(
                            event: event,
                            padding: entry.eventPadding,
                            dimension: dimension
                        )
                    } else {
                        QuickEventItemView(
                            event: event,
                            padding: entry.eventPadding,
                            dimension: dimension
                        )
                    }
                }
            }
            .width(entry.displaySize.width - entry.horizontalPadding * 2 - categoryItemSize.width - 8)
        }
        .padding(.vertical, entry.verticalPadding)
        .padding(.horizontal, entry.horizontalPadding)
    }
}

// #Preview {
//    let categories = CategoryEntity.random(count: 9)
//    let quickCategoryEntity = QuickCategoryEntity(categories: categories, events: categories.first!.events)
//    let entity = QuickTimelineEntry(category: quickCategoryEntity)
//    if #available(iOSApplicationExtension 17.0, *) {
//        QuickEntryView(entry: entity)
//    } else {
//        EmptyView()
//    }
// }
