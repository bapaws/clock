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
                                    let view = EventDetailView(store: store)
                                    pushView(view, title: event.name)
                                }
                            }

                            ui.background.frame(height: 8)
                        } header: {
                            HStack {
                                CategoryView(category: category)
                                Spacer()

                                if category.archivedAt != nil {
                                    Button {
                                        store.send(.unarchiveCategory(category))
                                    } label: {
                                        Text(R.string.localizable.unarchive())
                                            .font(.callout)
                                            .padding(.small)
                                    }
                                    .buttonStyle(.borderless)
                                    .foregroundStyle(ui.primary)
                                }
                            }
                            .padding(.horizontal)
                            .background(ui.background)
                        }
                    }
                }
                .padding(.vertical)
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
        store: StoreOf<ArchivedEventsFeature>(initialState: .init(), reducer: { ArchivedEventsFeature() })
    )
}
