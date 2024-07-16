//
//  EventsHomeOtherCategoriesFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/14.
//

import ComposableArchitecture
import HoursShare
import WidgetKit

@Reducer
struct EventsHomeOtherCategoriesFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = []

        @Presents var alert: AlertState<Alert>?
    }

    @CasePathable
    enum Alert: Equatable {
        case deleteCategory(CategoryEntity)
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)

        case update([CategoryEntity])

        case newCategoryTapped(CategoryEntity?)
        case deleteCategory(CategoryEntity)
        case archiveCategory(CategoryEntity)

        case removeCategory(CategoryEntity)

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

            case .deleteCategory(let entity):
                state.alert = AlertState {
                    TextState(R.string.localizable.warning())
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState(R.string.localizable.cancel())
                    }
                    ButtonState(role: .destructive, action: .deleteCategory(entity)) {
                        TextState(R.string.localizable.delete())
                    }
                } message: {
                    TextState(R.string.localizable.deleteCategoryWarning(entity.title, entity.title))
                }
                return .none

            case .alert(.presented(.deleteCategory(let entity))):
                return .run { send in
                    await AppRealm.shared.deleteCategory(entity)
                    await send(.removeCategory(entity), animation: .default)

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            case .archiveCategory(let entity):
                return .run { send in
                    await AppRealm.shared.archiveCategory(entity)
                    await send(.removeCategory(entity))

                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Events.large)
                }

            case .removeCategory(let entity):
                state.categories.removeAll(where: { $0.id == entity.id })
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
