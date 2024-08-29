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
                ForEach(quickCategory.categories) { category in
                    let intent = QuickSelectCategoryAppIntent(categoryID: category.id, family: quickCategory.family)
                    Button(intent: intent) {
                        let isSelected = quickCategory.selection == category

                        HStack(spacing: 0) {
                            Text(category.title)
                                .fontWeight(isSelected ? .bold : .regular)
                                .padding(.vertical, quickCategory.padding)
                            Spacer()
                            if isSelected {
                                Capsule()
                                    .fill(category.primary)
                                    .frame(width: 2, height: 18)
                            }
                        }
                        .font(isSelected ? .footnote : .caption2)
                        .foregroundStyle(isSelected ? category.primary : ui.secondaryLabel)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .frame(categoryItemSize)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
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
                                padding: quickCategory.padding,
                                dimension: dimension
                            )
                        }
                    }

                    Spacer()
                }
            }
            .width(entry.displaySize.width - categoryItemSize.width - 8 - 32)
        }
        .padding(16)
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
