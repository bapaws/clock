//
//  EventsHomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import OrderedCollections
import RealmSwift
import SwiftUI
import SwiftUIX

struct EventsHomeView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeFeature>

    @EnvironmentObject var ui: UIManager

    var body: some View {
        ScrollViewReader { proxy in
            WithPerceptionTracking {
                LoadingView(isLoading: $store.isLoading) {
                    VStack {
                        NavigationBar(R.string.localizable.events()) {
                            menu
                        }

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

                                HStack {
                                    Spacer()
                                    Text(R.string.localizable.showAll())
                                    Image(systemName: "chevron.forward")
                                        .animation(.easeInOut, value: store.isOtherCategoriesShow)
                                        .rotationEffect(store.isOtherCategoriesShow ? .degrees(90) : .zero)
                                    Spacer()
                                }
                                .foregroundStyle(ui.secondaryLabel)
                                .padding(.vertical, .large)
                                .id(R.string.localizable.showAll())
                                .padding(.horizontal)
                                .onTapGesture {
                                    toggleOtherCategory(for: proxy)
                                }

                                if store.isOtherCategoriesShow {
                                    EventsHomeOtherCategoriesView(
                                        store: store.scope(state: \.otherCategories, action: \.otherCategories)
                                    )
                                }
                            }
                        }
                        .background(ui.background)
                        .onChange(of: store.isOtherCategoriesShow) { newValue in
                            guard newValue else { return }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    proxy.scrollTo(R.string.localizable.showAll(), anchor: .top)
                                }
                            }
                        }
                    }
                    .background(ui.background)
                    .onAppear {
                        store.send(.onAppear)
                    }
                }

                .navigationDestination(item: $store.scope(state: \.eventDetail, action: \.eventDetail)) {
                    EventDetailView(store: $0)
                }
                .navigationDestination(item: $store.scope(state: \.archivedEvents, action: \.archivedEvents)) {
                    ArchivedEventsView(store: $0)
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

                // MARK: New Event

                .sheet(item: $store.scope(state: \.newEvent, action: \.newEvent)) {
                    NewEventView(store: $0)
                        .sheetStyle()
                }

                // MARK: New Category

                .sheet(item: $store.scope(state: \.newCategory, action: \.newCategory)) {
                    NewCategoryView(store: $0)
                        .sheetStyle()
                }
            }
        }
    }

    private var menu: some View {
        Menu {
            Button(R.string.localizable.newEvent(), systemImage: "plus", role: nil) {
                store.send(.newEventTapped(nil))
            }
            Button(R.string.localizable.newCategory(), systemImage: "folder.badge.plus", role: nil) {
                store.send(.newCategoryTapped)
            }

            Divider()

            Button(R.string.localizable.archived(), systemImage: "archivebox.fill", role: nil) {
                // 先发送 action，再获取 store 进行 push
                store.send(.onArchivedEventsTapped)
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding(.leading)
                .padding(.vertical)
                .font(.title3)
        }
    }

    private func toggleOtherCategory(for proxy: ScrollViewProxy) {
        if store.isOtherCategoriesShow {
            store.send(.toggleOtherCategoriesShow, animation: .default)
        } else {
            store.send(.toggleOtherCategoriesShow)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation {
                    proxy.scrollTo(R.string.localizable.showAll(), anchor: .top)
                }
            }
        }
    }
}

#Preview {
    EventsHomeView(
        store: StoreOf<EventsHomeFeature>(
            initialState: .init(),
            reducer: { EventsHomeFeature() }
        )
    )
}
