//
//  QuickSelectEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/12.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftUI

@Reducer
struct QuickSelectEventFeature {
    @ObservableState
    struct State: Equatable {
        var categories: [CategoryEntity] = .init()
        var selectedEventIDs: [String: Set<String>] = [:]
        var widget: QuickWidgetEntity?

        var maxCategoryCount: Int
        var maxEventCount: Int

        var isLoading = true
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case upadteCategories([CategoryEntity])

        case didSelectedEvent(CategoryEntity, EventEntity)
        case updateWidget([QuickCategoryEntity])

        case onCompleted(QuickWidgetEntity?)
    }

    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let categories = await AppRealm.shared.getAllUnarchivedCategories()
                        .filter { !$0.events.isEmpty }
                    await send(.upadteCategories(categories), animation: .default)
                }
            case .upadteCategories(let entities):
                state.categories.removeAll()
                state.categories.append(contentsOf: entities)

                if let categories = state.widget?.categories {
                    for category in categories {
                        var eventIDs = Set<String>()
                        for id in category.events.map({ $0.id }) {
                            eventIDs.insert(id)
                        }
                        state.selectedEventIDs[category.id] = eventIDs
                    }
                }
                state.isLoading = false
                return .none
            case .didSelectedEvent(let category, let entity):
                if let eventIDs = state.selectedEventIDs[category.id] {
                    if eventIDs.contains(entity.id) {
                        state.selectedEventIDs[category.id]?.remove(entity.id)
                    } else if eventIDs.count < state.maxEventCount {
                        state.selectedEventIDs[category.id]?.insert(entity.id)
                    } else {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        Toast.show(L10n.selectEventsWarning(state.maxEventCount))
                    }
                } else if state.selectedEventIDs.count < state.maxCategoryCount {
                    state.selectedEventIDs[category.id] = [entity.id]
                } else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    Toast.show(L10n.selectCategoriesWarning(state.maxCategoryCount))
                }

                return .run { [selectedEventIDs = state.selectedEventIDs, categories = state.categories] send in
                    let quickCategories: [QuickCategoryEntity] = categories.compactMap { category in
                        guard let eventIDs = selectedEventIDs[category.id] else { return nil }
                        var quickCategory = QuickCategoryEntity(entity: category)
                        quickCategory.events = category.events.compactMap { eventIDs.contains($0.id) ? QuickEventEntity(entity: $0) : nil }
                        return quickCategory
                    }
                    await send(.updateWidget(quickCategories))
                }
            case .updateWidget(let categories):
                if categories.isEmpty {
                    state.widget = nil
                } else if state.widget == nil {
                    state.widget = QuickWidgetEntity(categories: categories)
                } else {
                    state.widget?.categories = categories
                }
                return .none

            case .onCompleted:
                return .run { _ in await dismiss() }

            default:
                return .none
            }
        }
    }
}

struct QuickSelectEventView: View {
    @Perception.Bindable var store: StoreOf<QuickSelectEventFeature>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                WithPerceptionTracking {
                    LoadingView(isLoading: $store.isLoading) {
                        VStack {
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 8, pinnedViews: .sectionHeaders) {
                                    WithPerceptionTracking {
                                        ForEach(store.categories) { category in
                                            Section {
                                                ForEach(category.events) { event in
                                                    HStack(spacing: 16) {
                                                        HStack(spacing: 12) {
                                                            RoundedRectangle(cornerRadius: 2)
                                                                .fill(event.primary)
                                                                .frame(width: 4)
                                                            if let emoji = event.emoji, !emoji.isEmpty {
                                                                Text(emoji)
                                                                    .padding(.small)
                                                            }
                                                            Text(event.name)
                                                                .font(.body, weight: .regular)
                                                        }
                                                        .padding(.leading)
                                                        .padding(.vertical)

                                                        Spacer()

                                                        if let eventIDs = store.selectedEventIDs[category.id], eventIDs.contains(event.id) {
                                                            Image(systemName: "checkmark")
                                                                .font(.system(.callout, design: .rounded))
                                                                .foregroundStyle(ui.primary)
                                                                .padding(12)
                                                        }
                                                    }
                                                    .padding(.trailing)
                                                    .frame(height: cellHeight)
                                                    .background(ui.secondaryBackground)
                                                    .cornerRadius(16)
                                                    .onTapGesture {
                                                        store.send(.didSelectedEvent(category, event))
                                                    }
                                                }

                                                ui.background.frame(height: 16)
                                            } header: {
                                                HStack {
                                                    CategoryView(category: category)
                                                    Spacer()
                                                }
                                                .padding(.vertical, .small)
                                                .background(ui.background)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .padding(.vertical)
                            }

                            Button {
                                store.send(.onCompleted(store.widget))
                            } label: {
                                Label(L10n.save, systemImage: "square.and.arrow.down")
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 44)
                                    .foregroundStyle(Color.white)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                        }
                    }
                    .background(ui.background)
                    .navigationTitle(L10n.selectEvent)
                    .navigationBarItems(trailing: Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                    }))
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

// #Preview {
//    QuickSelectEventView(
//        store: StoreOf<QuickSelectEventFeature>(initialState: .init(), reducer: { QuickSelectEventFeature() })
//    )
// }
