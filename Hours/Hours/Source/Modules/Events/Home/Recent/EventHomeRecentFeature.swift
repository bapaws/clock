//
//  EventHomeRecentFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/5.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct EventHomeRecentFeature {
    @ObservableState
    struct State: Equatable {
        var events: IdentifiedArrayOf<EventEntity> = []
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case updateEvents([EventEntity])

        case onEventTapped(EventEntity)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let events = await AppRealm.shared.getRecentEvents()
                    await send(.updateEvents(events))
                }

            case let .updateEvents(entities):
                state.events.removeAll()
                state.events.append(contentsOf: entities)
                return .none

            default:
                return .none
            }
        }
    }
}
