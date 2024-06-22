//
//  NewCategoryFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct NewCategoryFeature {
    @ObservableState
    struct State: Equatable {
        var category: CategoryEntity?

        var newestCategoryID: String?
        var emoji: String = ""
        var title: String = ""

        var createAttempts = 0
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case cancel
        case save
        case saveCompleted(CategoryEntity)

        case updateNewestCategoryID(String)
    }

    @Dependency(\.dismiss) private var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .cancel:
                return .run { _ in await dismiss() }

            case .save:
                let name = state.title.trimmingCharacters(in: .whitespacesAndNewlines)
                if name.isEmpty {
                    state.createAttempts += 1
                    return .none.animation()
                }

                return .run { [state] send in
                    if var category = state.category {
                        category.emoji = state.emoji
                        category.name = state.title
                        await AppRealm.shared.writeCategory(category)

                        await send(.saveCompleted(category))
                    } else {
                        let hex = await AppRealm.shared.nextHex
                        let newCategory = CategoryEntity(hex: hex, emoji: state.emoji, name: state.title)
                        await AppRealm.shared.writeCategory(newCategory)

                        await send(.saveCompleted(newCategory))
                    }

                    await dismiss()
                }

            case .updateNewestCategoryID(let id):
                state.newestCategoryID = id
                return .none
            default:
                return .none
            }
        }
    }
}
