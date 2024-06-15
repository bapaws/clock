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
    var entry: QuickCategoryEntity
    var isClickEnabled: Bool = true

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                ForEach(entry.categories) { category in
                    let content = Group {
                        if entry.selection == category {
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
                    .padding(.vertical, entry.padding)

                    if isClickEnabled {
                        let intent = SelectCategoryAppIntent(categoryID: category.id, family: entry.family)
                        Button(intent: intent) {
                            content
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    } else {
                        content
                    }
                }
                Spacer()
            }
            .width(entry.categoryWidth)

            Divider().frame(width: 1)

            LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                let events = (entry.selection ?? entry.categories[0]).events
                ForEach(0 ..< min(entry.maxEventCount, events.count), id: \.self) { index in
                    let event = events[index]
                    let content = VStack {
                        Spacer()
                        if let emoji = event.emoji {
                            Text(emoji)
                        }
                        Spacer()
                        Text(event.name)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .font(.subheadline)
                            .foregroundStyle(event.primary)
                        Spacer()
                    }
                    .padding(entry.padding)
                    .frame(width: entry.dimension, height: entry.dimension, alignment: .center)
                    .background(event.primaryContainer)
                    .cornerRadius(16)

                    if isClickEnabled {
                        Button(intent: QuickStartTimerAppIntent(eventID: event.id)) {
                            content
                        }
                        .buttonStyle(.borderless)
                    } else {
                        content
                    }
                }
            }
            .maxWidth(.infinity)
        }
        .padding()
    }
}
