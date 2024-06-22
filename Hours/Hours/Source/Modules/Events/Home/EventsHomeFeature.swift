//
//  EventsHomeFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/15.
//

import ComposableArchitecture
import Foundation
import HoursShare
import OrderedCollections
import RealmSwift
import SwiftDate

@Reducer
struct EventsHomeFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = []
        var otherCategories: [CategoryEntity] = []

        var isOtherCategoriesShow = false

        var isLoading = false

        @Presents var newCategory: NewCategoryFeature.State?
        @Presents var newEvent: NewEventFeature.State?
        @Presents var newRecord: NewRecordFeature.State?

        @Presents var archivedEvents: ArchivedEventsFeature.State?
        @Presents var eventDetail: EventDetailFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case updateCategories([CategoryEntity])

        case toggleOtherCategoriesShow

        case deleteEvent(EventEntity)
        case archiveEvent(EventEntity)

        // MARK: State

        // 从列表中删除事件
        case removeEvent(EventEntity)
        case saveEventCompleted(EventEntity)
        case saveCategoryCompleted(CategoryEntity)

        // MARK: New Category

        case newCategoryTapped
        case newCategory(PresentationAction<NewCategoryFeature.Action>)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)
        case newEvent(PresentationAction<NewEventFeature.Action>)

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

    @Dependency(\.date.now) private var now

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let entities = await AppRealm.shared.getAllUnarchivedCategories()
                    await send(.updateCategories(entities), animation: .default)
                }

            case .updateCategories(let entities):
                state.categories.removeAll()
                state.otherCategories.removeAll()
                for entity in entities {
                    if entity.events.isEmpty {
                        state.otherCategories.append(entity)
                    } else {
                        state.categories.append(entity)
                    }
                }
                return .none

            case .toggleOtherCategoriesShow:
                state.isOtherCategoriesShow.toggle()
                return .none

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

            case .newCategoryTapped:
                state.newCategory = .init()
                return .none

            case .newEventTapped(let category):
                state.newEvent = .init(category: category)
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

            case .updateNewRecordState(let newRecordState):
                state.newRecord = newRecordState
                return .none

            case .onArchivedEventsTapped:
                state.archivedEvents = .init()
                return .none

            case .onEventTapped(let entity):
                state.isLoading = true
                // 先加载再进入详情页面
                return .run { send in
                    let records = await AppRealm.shared.sectionedRecords(entity, by: { $0.endAt.dateAt(.startOfDay) })

                    var eventDetail = EventDetailFeature.State(event: entity)
                    eventDetail.records = records
                    eventDetail.recordCount = records.reduce(0) { $0 + $1.value.count }
                    await send(.onEventDetailLoaded(eventDetail))
                }

            case .onEventDetailLoaded(let eventDetail):
                state.eventDetail = eventDetail
                state.isLoading = false
                return .none

            // MARK: New Callback

            case .newCategory(.presented(.saveCompleted(let entity))):
                return .run { send in await send(.saveCategoryCompleted(entity), animation: .default) }

            case .newEvent(.presented(.saveCompleted(let entity))):
                return .run { send in await send(.saveEventCompleted(entity), animation: .default) }

            // MARK: Update State

            case .removeEvent(let entity):
                for (index, category) in state.categories.enumerated() where category.id == entity.category?.id {
                    if let firstIndex = category.events.firstIndex(where: { $0.id == entity.id }) {
                        state.categories[index].events.remove(at: firstIndex)
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
                for (index, category) in state.otherCategories.enumerated() {
                    if category.id == entity.category?.id {
                        state.otherCategories[index].events.append(entity)
                        return .none
                    }
                }
                return .none

            case .saveCategoryCompleted(let entity):
                if let index = state.categories.firstIndex(where: { $0.id == entity.id }) {
                    state.categories[index] = entity
                } else if let index = state.otherCategories.firstIndex(where: { $0.id == entity.id }) {
                    state.otherCategories[index] = entity
                } else {
                    state.otherCategories.insert(entity, at: 0)
                    state.isOtherCategoriesShow = true
                }
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$newCategory, action: \.newCategory) {
            NewCategoryFeature()
        }
        .ifLet(\.$newEvent, action: \.newEvent) {
            NewEventFeature()
        }
        .ifLet(\.$newRecord, action: \.newRecord) {
            NewRecordFeature()
        }
        .ifLet(\.$archivedEvents, action: \.archivedEvents) {
            ArchivedEventsFeature()
        }
        .ifLet(\.$eventDetail, action: \.eventDetail) {
            EventDetailFeature()
        }
    }
}
