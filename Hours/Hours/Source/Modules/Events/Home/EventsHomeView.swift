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

    // MARK: Category

    @State private var isNewCategoryPresented: Bool = false
    @State private var newestCategoryID: String? = nil

    // MARK: Event

    @State private var newEventSelectCategory: CategoryEntity?
    @State private var isNewEventPresented: Bool = false

    // MARK: Record

    @State private var newRecordSelectEvent: EventEntity?

    // MARK: Timer

    @State private var timerSelectEvent: EventEntity?

//    @StateObject private var vm = EventsHomeViewModel()

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
                                ForEach(store.categories) { category in
                                    Section {
                                        ForEach(category.events) { event in
                                            EventItemView(event: event, playAction: presentTimer)
                                                .onTapGesture {
                                                    store.send(.onEventTapped(event))
                                                }
                                                .contextMenu { menuItems(for: event) }
                                        }

                                        ui.background
                                    } header: {
                                        EventsHeaderView(category: category) { category in
                                            store.send(.newEventTapped(category))
                                        }
                                    }
                                }

                                Button {
                                    toggleOtherCategory(for: proxy)
                                } label: {
                                    HStack {
                                        Text(R.string.localizable.showAll())
                                        Image(systemName: "chevron.forward")
                                            .animation(.easeInOut, value: store.isOtherCategoriesShow)
                                            .rotationEffect(store.isOtherCategoriesShow ? .degrees(90) : .zero)
                                    }
                                    .foregroundStyle(ui.secondaryLabel)
                                    .padding(.vertical, .large)
                                }
                                .id(R.string.localizable.showAll())

                                if store.isOtherCategoriesShow {
                                    ForEach(store.otherCategories) { category in
                                        EventsHeaderView(category: category) { category in
                                            store.send(.newEventTapped(category))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .onChange(of: store.isOtherCategoriesShow) { newValue in
                                guard newValue else { return }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    withAnimation {
                                        proxy.scrollTo(R.string.localizable.showAll(), anchor: .top)
                                    }
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
                    EventDetailView(store: $0, timerSelectEvent: $timerSelectEvent)
                }
                .navigationDestination(item: $store.scope(state: \.archivedEvents, action: \.archivedEvents)) {
                    ArchivedEventsView(store: $0, timerSelectEvent: $timerSelectEvent)
                }

                // MARK: Timer

                .fullScreenCover(item: $timerSelectEvent) { event in
                    TimerView(event: event)
                        .environmentObject(TimerManager.shared)
                }

                // MARK: New Record

                .sheet(item: $store.scope(state: \.newRecord, action: \.newRecord)) {
                    NewRecordView(store: $0)
                        .sheetStyle()
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

//                guard let store = store.scope(state: \.archivedEvents, action: \.archivedEvents) else { return }
//                let view = ArchivedEventsView(
//                    store: store,
//                    timerSelectEvent: $timerSelectEvent
//                )
//                pushView(view, title: R.string.localizable.archived())
            }
        } label: {
            Image(systemName: "ellipsis")
                .padding(.leading)
                .padding(.vertical)
                .font(.title3)
        }
    }

    @ViewBuilder func menuItems(for event: EventEntity) -> some View {
        WithPerceptionTracking {
            Button {
                store.send(.newRecordTapped(event))
            } label: {
                Label(R.string.localizable.newRecord(), systemImage: "plus")
            }
            Button {
                timerSelectEvent = event
            } label: {
                Label(R.string.localizable.startTimer(), systemImage: "play")
            }
            Divider()

            Button(action: {
                store.send(.archiveEvent(event))
            }) {
                Label(R.string.localizable.archive(), systemImage: "archivebox")
            }
        }
    }

    private func presentTimer(event: EventEntity) {
        timerSelectEvent = event
    }

    private func toggleOtherCategory(for proxy: ScrollViewProxy) {
        if store.isOtherCategoriesShow {
            withAnimation {
                store.send(.toggleOtherCategoriesShow)
            }
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
