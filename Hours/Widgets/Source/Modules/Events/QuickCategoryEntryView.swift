//
//  QuickCategoryEntryView.swift
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
struct QuickCategoryEntryView: View {
    var entry: QuickTimelineEntry
    var quickCategory: QuickCategoryEntity {
        entry.category
    }

    private let spacing: CGFloat
    private let dimension: CGFloat
    init(entry: QuickTimelineEntry) {
        self.entry = entry
        self.spacing = entry.category.spacing
        self.dimension = entry.category.dimension
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                ForEach(quickCategory.categories) { category in
                    let intent = SelectCategoryAppIntent(categoryID: category.id, family: quickCategory.family)
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
                        .font(.footnote)
                        .foregroundStyle(isSelected ? category.primary : ui.secondaryLabel)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
            }
            .width(quickCategory.categoryWidth)

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
                }
            }
            .width(entry.displaySize.width - quickCategory.categoryWidth - 8 - 32)
        }
        .padding(16)
    }
}

#Preview {
    let categories = CategoryEntity.random(count: 9)
    let entity = QuickTimelineEntry(categories: categories)
    if #available(iOSApplicationExtension 17.0, *) {
        return QuickCategoryEntryView(entry: entity)
    } else {
        return EmptyView()
    }
}
