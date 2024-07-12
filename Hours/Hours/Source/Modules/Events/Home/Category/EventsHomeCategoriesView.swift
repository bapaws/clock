//
//  EventsHomeCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/12.
//

import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftUI

@Reducer
struct EventsHomeCategoriesFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = []

        @Presents var newRecord: NewRecordFeature.State?

        @Presents var archivedEvents: ArchivedEventsFeature.State?
        @Presents var eventDetail: EventDetailFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case update([CategoryEntity])

        case deleteEvent(EventEntity)
        case archiveEvent(EventEntity)

        case onTimerStarted(EventEntity)

        case saveEventCompleted(EventEntity)

        // 从列表中删除事件
        case removeEvent(EventEntity)
        case moveToOther(CategoryEntity)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)

        // MARK: New Record

        case newRecordTapped(EventEntity?)
        case newRecord(PresentationAction<NewRecordFeature.Action>)
        case updateNewRecordState(NewRecordFeature.State)

        // MARK: Archived Events

        case onArchivedEventsTapped
        case archivedEvents(PresentationAction<ArchivedEventsFeature.Action>)

        // MARK: Event Detail

        case eventDetail(PresentationAction<EventDetailFeature.Action>)
        case onEventTapped(EventEntity)
        case onEventDetailLoaded(EventDetailFeature.State)
    }

    @Dependency(\.date.now) var now

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .update(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)
                return .none

            case .newRecordTapped(let event):
                return .run { send in
                    guard let event else { return }
                    let startOfDay = now.dateAtStartOf(.day)
                    let endOfDay = now.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords(
                        where: { $0.events._id == event._id && $0.endAt >= startOfDay && $0.endAt <= endOfDay }
                    )
                    let record = records.first

                    let startAt = record?.endAt ?? now.addingTimeInterval(-3600)
                    let endAt = startAt.addingTimeInterval(3600)
                    let state = NewRecordFeature.State(event: event, startAt: startAt, endAt: endAt)
                    await send(.updateNewRecordState(state))
                }

            case .onEventTapped(let entity):
                return .run { send in
                    let records = await AppRealm.shared.sectionedRecords(entity, by: { $0.endAt.dateAt(.startOfDay) })

                    var eventDetail = EventDetailFeature.State(event: entity)
                    eventDetail.records = records
                    eventDetail.recordCount = records.reduce(0) { $0 + $1.value.count }
                    await send(.onEventDetailLoaded(eventDetail))
                }

            case .deleteEvent(let entity):
                return .run { send in
                    await AppRealm.shared.deleteEvent(entity)
                    await send(.removeEvent(entity), animation: .default)
                }

            case .archiveEvent(let entity):
                return .run { send in
                    await AppRealm.shared.archiveEvent(entity)
                    await send(.removeEvent(entity), animation: .default)
                }

            case .removeEvent(let entity):
                for (index, category) in state.categories.enumerated() where category.id == entity.category?.id {
                    if let firstIndex = category.events.firstIndex(where: { $0.id == entity.id }) {
                        state.categories[index].events.remove(at: firstIndex)
                        if state.categories[index].events.isEmpty {
                            let entity = state.categories.remove(at: index)
                            return .run { send in
                                await send(.moveToOther(entity))
                            }
                        }
                        return .none
                    }
                }
                return .none

            case .saveEventCompleted(let entity):
                for (index, category) in state.categories.enumerated() where category.id == entity.category?.id {
                    if let firstIndex = category.events.firstIndex(where: { $0.id == entity.id }) {
                        state.categories[index].events[firstIndex] = entity
                        return .none
                    } else {
                        state.categories[index].events.append(entity)
                        return .none
                    }
                }
                return .none

            case .onTimerStarted(let entity):
                for (index, category) in state.categories.enumerated() where category.id == entity.category?.id {
                    state.categories[index].events.removeAll { $0.id == entity.id }
                }
                return .none

            default:
                return .none
            }
        }
    }
}

struct EventsHomeCategoriesView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeCategoriesFeature>
    var body: some View {
        WithPerceptionTracking {
            ForEach(store.categories) { category in
                Section {
                    ForEach(category.events) { event in
                        EventItemView(event: event) {
                            store.send(.onTimerStarted($0), animation: .default)
                        }
                        // 先调用 menu 的修改器，长按时不会出现圆角的情况
                        .contextMenu { menuItems(for: event) }
                        .onTapGesture {
                            store.send(.onEventTapped(event))
                        }
                        .cornerRadius(16)
                    }

                    ui.background
                } header: {
                    EventsHeaderView(category: category) { category in
                        store.send(.newEventTapped(category))
                    }
                }
                .padding(.horizontal)
            }
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
                store.send(.onTimerStarted(event))
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
}

#Preview {
    EventsHomeCategoriesView(
        store: StoreOf<EventsHomeCategoriesFeature>(
            initialState: .init(),
            reducer: { EventsHomeCategoriesFeature() }
        )
    )
}
