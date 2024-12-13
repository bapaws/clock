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

struct QuickEntryView: View {
    let entry: QuickTimelineEntry
    let action: (QuickCategoryEntity) -> Void

    private let categoryItemSize: CGSize
    private let dimension: CGFloat
    init(entry: QuickTimelineEntry, action: @escaping (QuickCategoryEntity) -> Void) {
        self.entry = entry
        self.categoryItemSize = entry.categoryItemSize
        self.dimension = entry.dimension
        self.action = action
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            let categories = entry.categories ?? []
            VStack(alignment: .leading, spacing: 0) {
                ForEach(0 ..< categories.count, id: \.self) { index in
                    let category = categories[index]

                    Button {
                        action(category)
                    } label: {
                        let isSelected = entry.widget?.selectedCategoryID == category.id
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
                        .font(isSelected ? .footnote : .caption2)
                        .foregroundStyle(isSelected ? category.primary : ui.secondaryLabel)
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
                        .frame(categoryItemSize)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                // 只有少于最大数量时，才需要填充空间
                if categories.count < entry.maxCategoryCount {
                    Spacer()
                }
            }
            .width(categoryItemSize.width)

            if let selectedEvents = entry.selectedEvents {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: entry.eventSpacing) {
                    ForEach(0 ..< min(entry.maxEventCount, selectedEvents.count), id: \.self) { index in
                        let event = selectedEvents[index]
                        if entry.family == .systemLarge {
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
