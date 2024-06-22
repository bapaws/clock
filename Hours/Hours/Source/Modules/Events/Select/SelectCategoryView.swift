//
//  SelectCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/12.
//

import ComposableArchitecture
import Flow
import Foundation
import HoursShare
import RealmSwift
import SwiftUI

@Reducer
struct SelectCategoryFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = .init()
        var selectedCategory: CategoryEntity?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case upadteCategories([CategoryEntity])

        case didSelectedCategory(CategoryEntity)
    }

    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let categories = await AppRealm.shared.getAllUnarchivedCategories()
                    await send(.upadteCategories(categories))
                }
            case .upadteCategories(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)
                return .none
            case .didSelectedCategory(let entity):
                state.selectedCategory = entity
                return .run { _ in await dismiss() }
            default:
                return .none
            }
        }
    }
}

// MARK: -

struct SelectCategoryView: View {
    @Perception.Bindable var store: StoreOf<SelectCategoryFeature>

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                HFlow(spacing: 12) {
                    ForEach(store.categories) { category in
                        CategoryView(category: category)
                            .onTapGesture {
                                store.send(.didSelectedCategory(category))
                            }
                    }
                }
                .padding()
                .padding(.vertical, .large)
            }
            .frame(.greedy, alignment: .leading)
            .background(ui.background)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    SelectCategoryView(
        store: StoreOf<SelectCategoryFeature>(initialState: .init(), reducer: { SelectCategoryFeature() })
    )
}
