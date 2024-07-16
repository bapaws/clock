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

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ForEach(quickCategory.categories) { category in
                    let content = Group {
                        if quickCategory.selection == category {
                            Text(category.title)
                                .fontWeight(.bold)
                                .foregroundStyle(category.primary)
                        } else {
                            Text(category.title)
                                .foregroundStyle(ui.secondaryLabel)
                        }
                    }
                    .font(.footnote)
                    .lineLimit(1)
                    .padding(.vertical, quickCategory.padding)

                    let intent = SelectCategoryAppIntent(categoryID: category.id, family: quickCategory.family)
                    Button(intent: intent) {
                        content
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                Spacer()
            }
            .width(quickCategory.categoryWidth)

            Divider().frame(width: 1)

            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                if let events = (quickCategory.selection ?? quickCategory.categories.first)?.events {
                    ForEach(0 ..< min(quickCategory.maxEventCount, events.count), id: \.self) { index in
                        let event = events[index]
                        if let entity = entry.timingEntities.first(where: { $0.id == event.id }) {
                            QuickTimingItemView(entity: entity, dimensions: quickCategory.dimension)
                        } else {
                            QuickEventItemView(
                                event: event,
                                padding: quickCategory.padding,
                                dimension: quickCategory.dimension
                            )
                        }
                    }
                }
            }
            .maxWidth(.infinity)
        }
        .padding()
    }
}
