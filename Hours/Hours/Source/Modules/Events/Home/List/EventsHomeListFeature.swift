//
//  EventsHomeListFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/17.
//

import ClockShare
import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift
import WidgetKit

@Reducer
struct EventsHomeListFeature {
    @ObservableState
    struct State: Equatable {
        var isOtherCategoriesShow = false

        var isLoading = false

        var categories: EventsHomeCategoriesFeature.State = .init()
        var otherCategories: EventsHomeOtherCategoriesFeature.State = .init()

        var recent: EventHomeRecentFeature.State = .init()
        var timing: TimingEventsFeature.State = .init()

        @Presents var newRecord: NewRecordFeature.State?
        @Presents var eventDetail: EventDetailFeature.State?

        @Presents var timer: TimerFeature.State?

        var isEmpty: Bool {
            categories.categories.isEmpty && otherCategories.categories.isEmpty
        }
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

        case newCategoryCompleted(CategoryEntity)

        // MARK: Timer

        case timer(PresentationAction<TimerFeature.Action>)

        // MARK: New Record

        case newRecord(PresentationAction<NewRecordFeature.Action>)
        case updateNewRecordState(NewRecordFeature.State)

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

            case .categories(.newRecordTapped(let event)):
                return .run { send in
                    guard let event else { return }
                    let startOfDay = now.dateAtStartOf(.day)
                    let endOfDay = now.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords {
                        $0.events._id == event._id &&
                            $0.endAt >= startOfDay &&
                            $0.endAt <= endOfDay
                    }

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

            case .newCategoryCompleted(let entity):
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
        .ifLet(\.$newRecord, action: \.newRecord) {
            NewRecordFeature()
        }
        .ifLet(\.$eventDetail, action: \.eventDetail) {
            EventDetailFeature()
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
    }
}
