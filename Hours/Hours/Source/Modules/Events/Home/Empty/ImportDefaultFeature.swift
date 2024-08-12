//
//  ImportDefaultFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/31.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct ImportDefaultFeature {
    @ObservableState
    struct State: Equatable {
        var categories: IdentifiedArrayOf<CategoryEntity> = []

        var shrinkCategoryIDs: Set<String> = []

        var isImporting: Bool = false

        struct CategorySelected: Identifiable, Equatable {
            var category: CategoryEntity

            var isEnable: Bool = true

            var isSelected: Bool = false
            var isAllEventSelected: Bool { selectedEventIDs.count + disableEventIDs.count == category.events.count }
            var isAllEventDisable: Bool { disableEventIDs.count == category.events.count }

            var disableEventIDs: Set<String> = []
            var selectedEventIDs: Set<String> = []

            var id: String { category.id }

            init(category: CategoryEntity) {
                self.category = category
            }

            init(event: EventEntity) {
                self.category = event.category!
                self.selectedEventIDs = [event.id]
            }
        }

        var selectedCategories: IdentifiedArrayOf<CategorySelected> = []

        enum CategorySelectState {
            case normal, selected, eventSelected
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case categoriesDidLoad([CategoryEntity])
        case disableEvent(CategoryEntity, EventEntity)

        case onCategoryTapped(CategoryEntity)
        case onEventTapped(CategoryEntity, EventEntity)

        case shrinkCategory(CategoryEntity)

        case onImportRecordsToggle

        case selectAll
        case unselectAll

        case close

        case startImporting
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let categories = CategoryEntity.defaults
                    await send(.categoriesDidLoad(categories), animation: .default)

                    for category in categories {
                        for event in category.events {
                            if await AppRealm.shared.getEvent(by: event.name, emoji: event.emoji) != nil {
                                await send(.disableEvent(category, event))
                            }
                        }
                    }
                }

            case .disableEvent(let category, let entity):
                if var selected = state.selectedCategories[id: category.id] {
                    selected.disableEventIDs.insert(entity.id)
                    state.selectedCategories[id: category.id] = selected
                } else {
                    var selected: State.CategorySelected = .init(category: category)
                    selected.disableEventIDs.insert(entity.id)
                    state.selectedCategories.append(selected)
                }

                return .none

            case .categoriesDidLoad(let entities):
                state.categories = .init(uniqueElements: entities)
                return .none

            case .onCategoryTapped(let entity):
                if state.isImporting { return .none }

                var selected: State.CategorySelected = state.selectedCategories[id: entity.id] ?? .init(category: entity)
                if selected.selectedEventIDs.isEmpty {
                    let ids = entity.events.filter { !selected.disableEventIDs.contains($0.id) }
                        .map { $0.id }
                    selected.selectedEventIDs = Set(ids)
                } else {
                    selected.selectedEventIDs.removeAll()
                }
                state.selectedCategories[id: entity.id] = selected

                return .none

            case .onEventTapped(let category, let entity):
                if state.isImporting { return .none }

                if state.selectedCategories[id: category.id]?.disableEventIDs.contains(entity.id) == true {
                    return .none
                }

                if var selected = state.selectedCategories[id: category.id] {
                    if selected.selectedEventIDs.contains(entity.id) {
                        selected.selectedEventIDs.remove(entity.id)
                    } else {
                        selected.selectedEventIDs.insert(entity.id)
                    }
                    state.selectedCategories[id: category.id] = selected
                } else {
                    var selected: State.CategorySelected = .init(category: category)
                    selected.selectedEventIDs.insert(entity.id)
                    state.selectedCategories.append(selected)
                }

                return .none

            case .shrinkCategory(let entity):
                if state.shrinkCategoryIDs.contains(entity.id) {
                    state.shrinkCategoryIDs.remove(entity.id)
                } else {
                    state.shrinkCategoryIDs.insert(entity.id)
                }
                return .none

            case .selectAll:
                if state.isImporting { return .none }

                for entity in state.categories {
                    var selected: State.CategorySelected = .init(category: entity)
                    selected.selectedEventIDs = Set(entity.events.map { $0.id })
                    state.selectedCategories.append(selected)
                }
                return .none

            case .unselectAll:
                if state.isImporting { return .none }
                state.selectedCategories.removeAll()
                return .none

            case .close:
                return .run { _ in await dismiss() }

            case .startImporting:
                state.isImporting = true
                return .run { [state] send in
                    var categories = [CategoryEntity]()
                    for var category in state.categories {
                        guard let selected = state.selectedCategories[id: category.id] else { continue }
                        category.events = category.events.filter { selected.selectedEventIDs.contains($0.id) }
                        categories.append(category)
                    }

                    await AppRealm.shared.importDefaults(categories: categories)

                    await send(.close)
                }

            default:
                return .none
            }
        }
    }
}
