//
//  EventsHomeOtherCategoriesView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/12.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

@Reducer
struct EventsHomeOtherCategoriesFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = []
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case update([CategoryEntity])

        case newCategory(CategoryEntity)
        case removeEvent(EventEntity)

        // MARK: New Event

        case newEventTapped(CategoryEntity?)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .update(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)
                return .none

            case .newCategory(let entity):
                state.categories.append(entity)
                return .none

            default:
                return .none
            }
        }
    }
}

struct EventsHomeOtherCategoriesView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeOtherCategoriesFeature>
    var body: some View {
        WithPerceptionTracking {
            ForEach(store.categories) { category in
                EventsHeaderView(category: category) { category in
                    store.send(.newEventTapped(category))
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    EventsHomeOtherCategoriesView(
        store: .init(initialState: .init(), reducer: {
            EventsHomeOtherCategoriesFeature()
        })
    )
}
