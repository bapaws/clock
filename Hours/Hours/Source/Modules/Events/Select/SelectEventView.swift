//
//  SelectEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/12.
//

import HoursShare
import RealmSwift
import SwiftUI

struct SelectEventView: View {
    @ObservedResults(
        CategoryObject.self,
        where: { $0.events[keyPath: \.archivedAt] == nil }
    )
    private var categories

    @Binding var selectedEvent: EventEntity?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: .sectionHeaders) {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.events) { event in
                            let entity = EventEntity(object: event)
                            EventItemView(event: entity)
                                .onTapGesture {
                                    selectedEvent = entity
                                    dismiss()
                                }
                        }
                    } header: {
                        HStack {
                            CategoryView(category: CategoryEntity(object: category))
                            Spacer()
                        }
                        .padding(.vertical, .small)
                        .background(ui.background)
                    }

                    ui.background
                }
            }
            .padding()
        }
        .background(ui.background)
    }
}

#Preview {
    SelectEventView(selectedEvent: .constant(EventEntity.random()))
}
