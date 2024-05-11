//
//  ArchivedEventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/10.
//

import ClockShare
import HoursShare
import SwiftDate
import SwiftUI
import SwiftUIX

struct ArchivedEventsView: View {
    @StateObject private var vm = ArchivedEventsViewModel()

    // MARK: Timer

    @Binding var timerSelectEvent: EventObject?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8, pinnedViews: .sectionHeaders) {
                ForEach(vm.categories.keys) { category in
                    if let events = vm.categories[category] {
                        Section {
                            ForEach(events) { event in
                                ArchivedEventsItemView(event: event, unarchiveEvent: vm.unarchiveEvent)
                                    .onTapGesture {
                                        pushView(EventDetailView(event: event, timerSelectEvent: $timerSelectEvent))
                                    }
                            }
                        } header: {
                            EventsHeaderView(category: category)
                        }
                    }
                }
            }
            .padding()
            .emptyStyle(isEmpty: vm.categories.isEmpty)
        }
        .background(ui.background)
        .navigationTitle(R.string.localizable.archived())
    }
}

#Preview {
    ArchivedEventsView(timerSelectEvent: .constant(EventObject()))
}
