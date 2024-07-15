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
import WidgetKit

@Reducer
struct EventsHomeFeature {
    @ObservableState
    struct State: Equatable {
        var isOtherCategoriesShow = false

        var isLoading = false

        var categories: EventsHomeCategoriesFeature.State = .init()
        var otherCategories: EventsHomeOtherCategoriesFeature.State = .init()

        var recent: EventHomeRecentFeature.State = .init()
        var timing: TimingEventsFeature.State = .init()

        @Presents var newCategory: NewCategoryFeature.State?
        @Presents var newEvent: NewEventFeature.State?
        @Presents var newRecord: NewRecordFeature.State?

        @Presents var archivedEvents: ArchivedEventsFeature.State?
        @Presents var eventDetail: EventDetailFeature.State?

        @Presents var timer: TimerFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadCompleted

        case toggleOtherCategoriesShow

        case categories(EventsHomeCategoriesFeature.Action)
        case otherCategories(EventsHomeOtherCategoriesFeature.Action)

        case recent(EventHomeRecentFeature.Action)
        case timing(TimingEventsFeature.Action)

        // MARK: Timer

        case timer(PresentationAction<TimerFeature.Action>)

        // MARK: New Category

        case newCategoryTapped
        case newCategory(PresentationAction<NewCategoryFeature.Action>)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)
        case newEvent(PresentationAction<NewEventFeature.Action>)

        // MARK: New Record

        case newRecord(PresentationAction<NewRecordFeature.Action>)
        case updateNewRecordState(NewRecordFeature.State)

        // MARK: Archived Events

        case onArchivedEventsTapped
        case archivedEvents(PresentationAction<ArchivedEventsFeature.Action>)

        // MARK: Event Detail

        case eventDetail(PresentationAction<EventDetailFeature.Action>)
    }

    @Dependency(\.date.now) private var now

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.categories, action: \.categories) {
            EventsHomeCategoriesFeature()
        }
        Scope(state: \.otherCategories, action: \.otherCategories) {
            EventsHomeOtherCategoriesFeature()
        }
        Scope(state: \.recent, action: \.recent) {
            EventHomeRecentFeature()
        }
        Scope(state: \.timing, action: \.timing) {
            TimingEventsFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let entities = await AppRealm.shared.getAllUnarchivedCategories()
                    let timingEntities = TimerManager.shared.timingEntities

                    var categories: [CategoryEntity] = []
                    var otherCategories: [CategoryEntity] = []
                    for var category in entities {
                        if category.events.isEmpty {
                            otherCategories.append(category)
                        } else {
                            // 移除正在计时的事件
                            category.events.removeAll { event in
                                timingEntities.contains(where: { $0.id == event.id })
                            }
                            categories.append(category)
                        }
                    }
                    await send(.categories(.update(categories)), animation: .default)
                    await send(.otherCategories(.update(otherCategories)), animation: .default)

                    // 重新加载正在计时中的事件
                    await send(.timing(.onAppear), animation: .default)
                    // 重新加载最近
                    await send(.recent(.onAppear), animation: .default)

                    // 发送加载完成消息，首页让 splash 页面消失
                    await send(.loadCompleted)
                }

            case .toggleOtherCategoriesShow:
                state.isOtherCategoriesShow.toggle()
                return .none

                // MARK: Categories

            case .newEventTapped(let category),
                 .categories(.newEventTapped(let category)),
                 .otherCategories(.newEventTapped(let category)):
                state.newEvent = .init(category: category)
                return .none

            case .categories(.newRecordTapped(let event)):
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

            case .categories(.onEventTapped):
                state.isLoading = true
                return .none

            case .categories(.onEventDetailLoaded(let eventDetail)):
                state.eventDetail = eventDetail
                state.isLoading = false
                return .none

            case .categories(.moveToOther(let entity)):
                state.otherCategories.categories.insert(entity, at: 0)
                return .none

                // MARK: NewCategory

            case .newCategoryTapped:
                state.newCategory = .init()
                return .none

            case .newCategory(.presented(.saveCompleted(let entity))):
                if let index = state.categories.categories.firstIndex(where: { $0.id == entity.id }) {
                    state.categories.categories[index] = entity
                } else if let index = state.otherCategories.categories.firstIndex(where: { $0.id == entity.id }) {
                    state.otherCategories.categories[index] = entity
                } else {
                    state.otherCategories.categories.insert(entity, at: 0)
                    state.isOtherCategoriesShow = true
                }
                return .none

                // MARK: EventDetail

            case .eventDetail(.presented(.newEvent(.presented(.saveCompleted(let entity))))):
                return .run { send in
                    await send(.categories(.saveEventCompleted(entity)), animation: .default)
                }

            case .eventDetail(.presented(.onTimerStarted(let entity))),
                 .recent(.onEventTapped(let entity)),
                 .categories(.onTimerStarted(let entity)):
                var timingEntity: TimingEntity
                // 如果已经是正在计时，获取后直接进入
                if let entity = TimerManager.shared.timingEntities.first(where: { $0.id == entity.id }) {
                    timingEntity = entity
                } else {
                    timingEntity = TimingEntity(event: entity)
                    // 更新首页的当前的计时
                    state.timing.entities.append(timingEntity)
                }

                // 进入计时页面
                state.timer = TimerFeature.State(entity: timingEntity)

                return .none

                // MARK: NewEvent

            case .newEvent(.presented(.saveCompleted(_))):
                return .run { send in
                    // 创建事件可能是分类里，也可能是其他里，情况多，直接重新刷新
                    await send(.onAppear)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

                // MARK: Archived

            case .onArchivedEventsTapped:
                state.archivedEvents = .init()
                return .none

                // MARK: Record

            case .updateNewRecordState(let newRecordState):
                state.newRecord = newRecordState
                return .none

                // MARK: Timing

            case .timing(.onTimingTapped(let entity)):
                // 进入计时页面
                state.timer = TimerFeature.State(entity: entity)
                return .none

            case .timer(.presented(.onDismissed)),
                 .timing(.stopTimer):
                return .run { [state] send in
                    if state.eventDetail != nil {
                        // 如果是详情页，需要刷新页面
                        await send(.eventDetail(.presented(.onAppear)))
                    }
                    await send(.onAppear)
                }

            case .timer(.presented(.minimize)):
                return .run { send in
                    // 重新加载正在计时中的事件
                    await send(.timing(.onAppear), animation: .default)
                }

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
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
        ._printChanges(.actionLabels)
    }
}
