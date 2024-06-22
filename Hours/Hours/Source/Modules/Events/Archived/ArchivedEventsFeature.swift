//
//  ArchivedEventsFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct ArchivedEventsFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = .init()

        var eventDetail: EventDetailFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case unarchiveEvent(EventEntity)

        case updateCategories([CategoryEntity])

        case eventDetail(EventDetailFeature.Action)
        case onEventTapped(EventEntity)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let categories = await AppRealm.shared.getAllArchivedCategories()
                    await send(.updateCategories(categories))
                }

            case .unarchiveEvent(let entity):
                return .run { send in
                    await AppRealm.shared.archiveEvent(entity)
                    await send(.onAppear)
                }

            case .updateCategories(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)
                return .none

            case .onEventTapped(let entity):
                state.eventDetail = .init(event: entity)
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.eventDetail, action: \.eventDetail) {
            EventDetailFeature()
        }
    }
}
