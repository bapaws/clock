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

    @Binding var selectedEvent: EventObject?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8, pinnedViews: .sectionHeaders) {
                ForEach(categories) { category in
                    Section {
                        ForEach(category.events) { event in
                            EventItemView(event: event)
                                .onTapGesture {
                                    selectedEvent = event
                                    dismiss()
                                }
                        }
                    } header: {
                        HStack {
                            CategoryView(category: category)
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
    SelectEventView(selectedEvent: .constant(EventObject()))
}
