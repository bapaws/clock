//
//  ArchivedEventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/10.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftDate
import SwiftUI
import SwiftUIX

struct ArchivedEventsView: View {
    @Perception.Bindable var store: StoreOf<ArchivedEventsFeature>

    // MARK: Timer

    @Binding var timerSelectEvent: EventEntity?

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack(spacing: 8, pinnedViews: .sectionHeaders) {
                    ForEach(store.categories) { category in
                        Section {
                            ForEach(category.events) { event in
                                ArchivedEventsItemView(event: event) {
                                    store.send(.unarchiveEvent($0), animation: .bouncy)
                                }
                                .onTapGesture {
                                    store.send(.onEventTapped(event))

                                    guard let store = store.scope(state: \.eventDetail, action: \.eventDetail) else { return }
                                    let view = EventDetailView(store: store, timerSelectEvent: $timerSelectEvent)
                                    pushView(view, title: event.name)
                                }
                            }
                        } header: {
                            EventsHeaderView(category: category)
                        }
                    }
                }
                .padding()
                .emptyStyle(isEmpty: store.categories.isEmpty)
            }
            .background(ui.background)
            .navigationTitle(R.string.localizable.archived())
            .toolbarRole(.editor)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    ArchivedEventsView(
        store: StoreOf<ArchivedEventsFeature>(initialState: .init(), reducer: { ArchivedEventsFeature() }),
        timerSelectEvent: .constant(EventEntity.random())
    )
}
