//
//  EventsHomeCategoriesFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/14.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift
import UIKit
import WidgetKit

@Reducer
struct EventsHomeCategoriesFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = []

        var dragCategory: CategoryEntity?
        var dragEvent: EventEntity?

        @Presents var alert: AlertState<Alert>?

        @Presents var eventDetail: EventDetailFeature.State?
    }

    @CasePathable
    enum Alert: Equatable {
        case deleteEvent(EventEntity)
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)

        case update([CategoryEntity])

        case deleteEvent(EventEntity)
        case archiveEvent(EventEntity)

        case archiveCategory(CategoryEntity)

        case onTimerStarted(EventEntity)

        case saveEventCompleted(EventEntity)

        // 从列表中删除事件
        case removeEvent(EventEntity)
        case moveToOther(CategoryEntity)

        // MARK: Drag & Drop

        case onEventDrag(EventEntity)
        case onEventDropUpdate(EventEntity, DragRelocateDelegate.Move)

        case onCategoryDrag(CategoryEntity)
        case onCategoryDropUpdate(CategoryEntity, DragRelocateDelegate.Move)

        case newCategoryTapped(CategoryEntity?)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)

        // MARK: New Record

        case newRecordTapped(EventEntity?)

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

            case .onEventTapped(let entity):
                return .run { send in
                    let records = await AppRealm.shared.sectionedRecords(entity, by: { $0.endAt.dateAt(.startOfDay) })

                    var eventDetail = EventDetailFeature.State(event: entity)
                    eventDetail.records = records
                    eventDetail.recordCount = records.reduce(0) { $0 + $1.value.count }
                    await send(.onEventDetailLoaded(eventDetail))
                }

            case .archiveCategory(let entity):
                state.categories.removeAll(where: { $0.id == entity.id })
                return .run { _ in
                    await AppRealm.shared.archiveCategory(entity)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            case .deleteEvent(let entity):
                state.alert = AlertState {
                    TextState(R.string.localizable.warning())
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState(R.string.localizable.cancel())
                    }
                    ButtonState(role: .destructive, action: .deleteEvent(entity)) {
                        TextState(R.string.localizable.delete())
                    }
                } message: {
                    TextState(R.string.localizable.deleteEventWarning(entity.title, entity.title))
                }
                return .none

            case .alert(.presented(.deleteEvent(let entity))):
                if let categoryIndex = state.categories.firstIndex(where: { $0.id == entity.category?.id }) {
                    state.categories[categoryIndex].eventTotalCount -= 1
                }
                return .run { send in
                    await AppRealm.shared.deleteEvent(entity)
                    await send(.removeEvent(entity), animation: .default)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            case .archiveEvent(let entity):
                return .run { send in
                    await AppRealm.shared.archiveEvent(entity)
                    await send(.removeEvent(entity), animation: .default)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
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

                // MARK: Drag & Drop

            case .onEventDrag(let event):
                state.dragEvent = event
                state.dragCategory = nil
                return .none

            case .onEventDropUpdate(let entity, let direction):
                guard state.dragCategory == nil, var dragEvent = state.dragEvent, dragEvent.id != entity.id else {
                    debugPrint("--------")
                    return .none
                }

                guard let categoryIndex = state.categories.firstIndex(where: { $0.id == dragEvent.category?.id }),
                      let eventIndex = state.categories[categoryIndex].events.firstIndex(where: { $0.id == dragEvent.id })
                else {
                    debugPrint("=====")
                    return .none
                }
                state.categories[categoryIndex].events.remove(at: eventIndex)

                guard let categoryIndex = state.categories.firstIndex(where: { $0.id == entity.category?.id }),
                      let eventIndex = state.categories[categoryIndex].events.firstIndex(where: { $0.id == entity.id })
                else {
                    debugPrint("++++++")
                    return .none
                }
                var category = state.categories[categoryIndex]
                category.events.removeAll()
                dragEvent.category = category
                state.dragEvent = dragEvent
                state.categories[categoryIndex].events.insert(dragEvent, at: eventIndex + direction.rawValue)

                return .run { [events = state.categories[categoryIndex].events, category] _ in
                    let impactMed = await UIImpactFeedbackGenerator(style: .light)
                    await impactMed.impactOccurred()

                    try await AppRealm.shared.reorder(by: events, in: category)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            case .onCategoryDrag(let category):
                state.dragEvent = nil
                state.dragCategory = category
                return .none

            case .onCategoryDropUpdate(let entity, let direction):
                guard state.dragEvent == nil,
                      let dragCategory = state.dragCategory,
                      dragCategory.id != entity.id
                else {
                    return .none
                }

                guard let categoryIndex = state.categories.firstIndex(where: { $0.id == dragCategory.id }) else {
                    return .none
                }
                state.categories.remove(at: categoryIndex)

                guard let categoryIndex = state.categories.firstIndex(where: { $0.id == entity.id }) else {
                    return .none
                }
                state.categories.insert(dragCategory, at: categoryIndex + direction.rawValue)

                return .run { [categories = state.categories] _ in
                    let impactMed = await UIImpactFeedbackGenerator(style: .light)
                    await impactMed.impactOccurred()

                    try await AppRealm.shared.reorder(by: categories)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
