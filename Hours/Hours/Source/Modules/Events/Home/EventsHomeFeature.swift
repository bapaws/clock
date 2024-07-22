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
        var list: EventsHomeListFeature.State = .init()

        @Presents var newCategory: NewCategoryFeature.State?
        @Presents var newEvent: NewEventFeature.State?

        @Presents var archivedEvents: ArchivedEventsFeature.State?

        @Presents var calendarEvents: CalendarEventsFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case loadCompleted

        case list(EventsHomeListFeature.Action)

        // MARK: New Category

        case newCategoryTapped
        case newCategory(PresentationAction<NewCategoryFeature.Action>)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)
        case newEvent(PresentationAction<NewEventFeature.Action>)

        // MARK: Archived Events

        case onArchivedEventsTapped
        case archivedEvents(PresentationAction<ArchivedEventsFeature.Action>)

        // MARK: Calendar Events

        case onImportCalendarEventsTapped
        case calendarEvents(PresentationAction<CalendarEventsFeature.Action>)
    }

    @Dependency(\.date.now) private var now

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.list, action: \.list) {
            EventsHomeListFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.list(.onAppear))

                    // 发送加载完成消息，首页让 splash 页面消失
                    await send(.loadCompleted)
                }

                // MARK: Categories

            case .newEventTapped(let category),
                 .list(.categories(.newEventTapped(let category))),
                 .list(.otherCategories(.newEventTapped(let category))):
                state.newEvent = .init(category: category)
                return .none

                // MARK: NewCategory

            case .newCategoryTapped:
                state.newCategory = .init()
                return .none

            case .list(.categories(.newCategoryTapped(let entity))),
                 .list(.otherCategories(.newCategoryTapped(let entity))):
                state.newCategory = .init(category: entity)
                return .none

            case .newCategory(.presented(.saveCompleted(let entity))):
                return .run { send in
                    await send(.list(.newCategoryCompleted(entity)))
                }

            case .calendarEvents(.dismiss):
                return .run { send in
                    await send(.list(.onAppear))
                }

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

            case .onImportCalendarEventsTapped:
                state.calendarEvents = .init()
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
        .ifLet(\.$archivedEvents, action: \.archivedEvents) {
            ArchivedEventsFeature()
        }
        .ifLet(\.$calendarEvents, action: \.calendarEvents) {
            CalendarEventsFeature()
        }
        ._printChanges(.actionLabels)
    }
}
