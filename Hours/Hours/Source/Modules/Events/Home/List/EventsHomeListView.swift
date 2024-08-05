//
//  EventsHomeListView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/17.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

struct EventsHomeListView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeListFeature>
    var body: some View {
        ScrollViewReader { proxy in
            WithPerceptionTracking {
                LoadingView(isLoading: $store.isLoading) {
                    WithPerceptionTracking {
                        ScrollView {
                            LazyVStack(spacing: 8, pinnedViews: .sectionHeaders) {
                                EventHomeRecentView(
                                    store: store.scope(state: \.recent, action: \.recent)
                                )

                                TimingEventsView(
                                    store: store.scope(state: \.timing, action: \.timing)
                                )

                                EventsHomeCategoriesView(
                                    store: store.scope(state: \.categories, action: \.categories)
                                )

                                if !store.categories.categories.isEmpty || !store.otherCategories.categories.isEmpty {
                                    HStack {
                                        Spacer()
                                        Text(L10n.showAll)
                                        Image(systemName: "chevron.forward")
                                            .animation(.easeInOut, value: store.isOtherCategoriesShow)
                                            .rotationEffect(store.isOtherCategoriesShow ? .degrees(90) : .zero)
                                        Spacer()
                                    }
                                    .foregroundStyle(ui.secondaryLabel)
                                    .padding(.vertical, .large)
                                    .id(L10n.showAll)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        toggleOtherCategory(for: proxy)
                                    }
                                }

                                if store.isOtherCategoriesShow {
                                    EventsHomeOtherCategoriesView(
                                        store: store.scope(state: \.otherCategories, action: \.otherCategories)
                                    )
                                }
                            }
                        }
                    }
                }
                .background(ui.background)
                .onChange(of: store.isOtherCategoriesShow) { newValue in
                    guard newValue else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation {
                            proxy.scrollTo(L10n.showAll, anchor: .top)
                        }
                    }
                }
                .navigationDestination(item: $store.scope(state: \.eventDetail, action: \.eventDetail)) {
                    EventDetailView(store: $0)
                }

                // MARK: Timer

                .fullScreenCover(item: $store.scope(state: \.timer, action: \.timer)) { store in
                    TimerView(store: store)
                }

                // MARK: New Record

                .sheet(item: $store.scope(state: \.newRecord, action: \.newRecord)) {
                    NewRecordView(store: $0)
                        .sheetStyle(detents: [.height(640)])
                }
            }
        }
    }

    private func toggleOtherCategory(for proxy: ScrollViewProxy) {
        if store.isOtherCategoriesShow {
            store.send(.toggleOtherCategoriesShow, animation: .default)
        } else {
            store.send(.toggleOtherCategoriesShow)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    proxy.scrollTo(L10n.showAll, anchor: .top)
                }
            }
        }
    }
}

#Preview {
    EventsHomeListView(
        store: StoreOf<EventsHomeListFeature>(
            initialState: .init(),
            reducer: { EventsHomeListFeature() }
        )
    )
}
