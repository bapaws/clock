//
//  SelectEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/12.
//

import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftUI

@Reducer
struct SelectEventFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = .init()
        var selectedEvent: EventEntity?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case upadteCategories([CategoryEntity])

        case didSelectedEvent(EventEntity)
    }

    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let categories = await AppRealm.shared.getAllUnarchivedCategories()
                        .filter { !$0.events.isEmpty }
                    await send(.upadteCategories(categories))
                }
            case .upadteCategories(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)
                return .none
            case .didSelectedEvent(let entity):
                state.selectedEvent = entity
                return .run { _ in await dismiss() }
            default:
                return .none
            }
        }
    }
}

struct SelectEventView: View {
    @Perception.Bindable var store: StoreOf<SelectEventFeature>

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8, pinnedViews: .sectionHeaders) {
                    ForEach(store.categories) { category in
                        Section {
                            ForEach(category.events) { event in
                                EventItemView(event: event)
                                    .onTapGesture {
                                        store.send(.didSelectedEvent(event))
                                    }
                            }
                        } header: {
                            HStack {
                                CategoryView(category: category)
                                Spacer()
                            }
                            .padding(.vertical, .small)
                            .background(ui.background)
                        }

                        ui.background
                    }
                }
                .padding()
            }
            .background(ui.background)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    SelectEventView(
        store: StoreOf<SelectEventFeature>(initialState: .init(), reducer: { SelectEventFeature() })
    )
}
