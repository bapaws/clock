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
        var recordsHome: RecordsHomeFeature.State = .init()

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
        case didEventsHomeLoad

        case statistics(Statistics.Action)
        case didStatisticsHomeLoad([CategoryEntity])

        case recordsHome(RecordsHomeFeature.Action)
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
            RecordsHomeFeature()
        }

        Reduce { state, action in
            switch action {
            case .didLoad:
                return .run { send in
                    debugPrint(Date.now.timeIntervalSince1970)
                    await send(.eventsHome(.onAppear))

                    // Records Home
                    let startOfDay = now.dateAtStartOf(.day)
                    let endOfDay = now.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords { $0.endAt >= startOfDay && $0.endAt <= endOfDay }
                    await send(.didRecordsHomeLoad(startOfDay, records))

                    await send(.didEventsHomeLoad)
                }

            case .didEventsHomeLoad:
                debugPrint(Date.now.timeIntervalSince1970)
                state.isLoadCompleted = true
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
