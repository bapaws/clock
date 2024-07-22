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

                    await send(.recordsHome(.onAppear))
                }

            case .eventsHome(.loadCompleted):
                debugPrint(Date.now.timeIntervalSince1970)
                if state.isLoadCompleted { return .none }
                state.isLoadCompleted = true
                return .none

            default:
                return .none
            }
        }
    }
}
