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
        ScrollViewReader { _ in
            WithPerceptionTracking {
                VStack {
                    NavigationBar(L10n.events) { menu }

                    EventsHomeListView(store: store.scope(state: \.list, action: \.list))
                }
                .background(ui.background)
                .onAppear {
                    store.send(.onAppear)
                }

                .navigationDestination(item: $store.scope(state: \.archivedEvents, action: \.archivedEvents)) {
                    ArchivedEventsView(store: $0)
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
                .sheet(item: $store.scope(state: \.calendarEvents, action: \.calendarEvents)) {
                    CalendarEventsView(store: $0)
                }
            }
        }
    }

    private var menu: some View {
        Menu {
            Button(L10n.newEvent, systemImage: "plus", role: nil) {
                store.send(.newEventTapped(nil))
            }
            Button(L10n.newCategory, systemImage: "folder.badge.plus", role: nil) {
                store.send(.newCategoryTapped)
            }

            Divider()

            Button(L10n.importFromCalendar, systemImage: "calendar.badge.plus", role: nil) {
                store.send(.onImportCalendarEventsTapped)
            }

            Divider()

            Button(L10n.archived, systemImage: "archivebox.fill", role: nil) {
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
}

#Preview {
    EventsHomeView(
        store: StoreOf<EventsHomeFeature>(
            initialState: .init(),
            reducer: { EventsHomeFeature() }
        )
    )
}
