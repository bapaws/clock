//
//  MainFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var eventsHome: EventsHomeFeature.State = .init()
        var statistics: Statistics.State = .init()
        var recordsHome: RecordsFeature.State = .init()

        var isLoadCompleted: Bool = false

#if DEBUG
        var selection: MainTabTag = .events
#else
        var selection: MainTabTag = .events
#endif
        var isPaywallPresented: Bool = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case didLoad

        case eventsHome(EventsHomeFeature.Action)
        case didEventsHomeLoad([CategoryEntity])

        case statistics(Statistics.Action)
        case didStatisticsHomeLoad([CategoryEntity])

        case recordsHome(RecordsFeature.Action)
        case didRecordsHomeLoad(Date, [RecordEntity])
    }

    @Dependency(\.date.now) var now

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.eventsHome, action: \.eventsHome) {
            EventsHomeFeature()
        }
        Scope(state: \.statistics, action: \.statistics) {
            Statistics()
        }
        Scope(state: \.recordsHome, action: \.recordsHome) {
            RecordsFeature()
        }

        Reduce { state, action in
            switch action {
            case .didLoad:
                return .run { send in
                    debugPrint(Date.now.timeIntervalSince1970)
                    // Events Home
                    let entities = await AppRealm.shared.getAllUnarchivedCategories()
                    await send(.didEventsHomeLoad(entities), animation: .default)

                    // Records Home
                    let startOfDay = now.dateAtStartOf(.day)
                    let endOfDay = now.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords { $0.endAt >= startOfDay && $0.endAt <= endOfDay }
                    await send(.didRecordsHomeLoad(startOfDay, records))
                }

            case let .didEventsHomeLoad(entities):
                debugPrint(Date.now.timeIntervalSince1970)
                state.isLoadCompleted = true
                state.eventsHome.categories.removeAll()
                state.eventsHome.otherCategories.removeAll()
                for entity in entities {
                    if entity.events.isEmpty {
                        state.eventsHome.otherCategories.append(entity)
                    } else {
                        state.eventsHome.categories.append(entity)
                    }
                }
                return .none

            case let .didRecordsHomeLoad(date, entities):
                state.recordsHome.timeline.items[id: date] = TimelinePageItem(date: date, records: entities)
                return .none

            default:
                return .none
            }
        }
    }
}
