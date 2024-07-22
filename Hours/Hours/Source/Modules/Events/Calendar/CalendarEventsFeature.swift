//
//  CalendarEventsFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/17.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct CalendarEventsFeature {
    @ObservableState
    struct State: Equatable {
        var startAt: Date
        var endAt: Date
        var categories: IdentifiedArrayOf<CategoryEntity>

        var shrinkCategoryIDs: Set<String> = []

        var isImportRecords: Bool = true
        var isLoading: Bool = true
        var isImporting: Bool = false

        struct CategorySelected: Identifiable, Equatable {
            var category: CategoryEntity

            var isSelected: Bool = true
            var isAllEventSelected: Bool { selectedEventIDs.count == category.events.count }

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

        init(categories: IdentifiedArrayOf<CategoryEntity> = []) {
            @Dependency(\.date.now) var now
            self.startAt = now.dateAt(.prevYear).date
            self.endAt = now
            self.categories = categories
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case categoriesDidLoad([CategoryEntity])

        case onCategoryTapped(CategoryEntity)
        case onEventTapped(EventEntity)

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
            case .binding(\.startAt), .binding(\.endAt):
                state.isLoading = true
                return .run { send in
                    await send(.onAppear)
                }
            case .onAppear:
                return .run { [startAt = state.startAt, endAt = state.endAt] send in
                    let categories = AppManager.shared.loadCalendars(startAt: startAt, endAt: endAt)
                    await send(.categoriesDidLoad(categories), animation: .default)
                }

            case .categoriesDidLoad(let entities):
                state.isLoading = false
                state.categories = .init(uniqueElements: entities)
                return .none

            case .onCategoryTapped(let entity):
                if state.isImporting { return .none }

                if state.selectedCategories[id: entity.id] == nil {
                    var selected: State.CategorySelected = .init(category: entity)
                    selected.selectedEventIDs = Set(entity.events.map { $0.id })
                    state.selectedCategories.append(selected)
                } else {
                    state.selectedCategories.remove(id: entity.id)
                }
                return .none

            case .onEventTapped(let entity):
                if state.isImporting { return .none }

                guard let id = entity.category?.id, let category = state.categories[id: id] else { return .none }

                if var selected = state.selectedCategories[id: category.id] {
                    if selected.selectedEventIDs.contains(entity.id) {
                        selected.selectedEventIDs.remove(entity.id)
                        // 没有选中的事件，删除选中的分类
                        if selected.selectedEventIDs.isEmpty {
                            state.selectedCategories.remove(id: id)
                        } else {
                            state.selectedCategories[id: category.id] = selected
                        }
                    } else {
                        selected.selectedEventIDs.insert(entity.id)
                        state.selectedCategories[id: category.id] = selected
                    }
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

            case .onImportRecordsToggle:
                if state.isImporting { return .none }

                state.isImportRecords.toggle()
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
                    for var category in state.categories {
                        guard let selected = state.selectedCategories[id: category.id] else { continue }

                        category.events = category.events.filter { selected.selectedEventIDs.contains($0.id) }

                        if state.isImportRecords {
                            await AppManager.shared.importRecordsFromCalendar(
                                by: category,
                                startAt: state.startAt,
                                endAt: state.endAt
                            )
                        } else {
                            await AppManager.shared.importEventsFromCalendar(
                                by: category,
                                startAt: state.startAt,
                                endAt: state.endAt
                            )
                        }
                    }

                    await send(.close)
                }

            default:
                return .none
            }
        }
    }
}
