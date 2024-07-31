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
        var hex: HexEntity

        var isLoading = false
        var createAttempts = 0
        
        @Presents var colorPick: ColorPickFeature.State?

        init(category: CategoryEntity? = nil) {
            self.category = category
            self.emoji = category?.emoji ?? ""
            self.title = category?.name ?? ""
            self.hex = category?.hex ?? .random
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case cancel
        case save
        case saveCompleted(CategoryEntity)

        case updateNewestCategoryID(String)
        
        case onColorPicked
        case colorPick(PresentationAction<ColorPickFeature.Action>)
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

                state.isLoading = true
                return .run { [state] send in
                    if var category = state.category {
                        category.emoji = state.emoji
                        category.name = state.title
                        await AppRealm.shared.writeCategory(category)

                        // 更新日历
                        AppManager.shared.updateCalendar(by: category)

                        await send(.saveCompleted(category))
                    } else {
                        let newCategory = CategoryEntity(hex: state.hex, emoji: state.emoji, name: state.title)
                        await AppRealm.shared.writeCategory(newCategory)

                        await send(.saveCompleted(newCategory))
                    }

                    await dismiss()
                }

            case .updateNewestCategoryID(let id):
                state.newestCategoryID = id
                return .none

            case .onColorPicked:
                state.colorPick = ColorPickFeature.State(hex: state.hex)
                return .none

            case .colorPick(.presented(.didSelectHex(let entity))):
                state.hex = entity
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$colorPick, action: \.colorPick) {
            ColorPickFeature()
        }
    }
}
