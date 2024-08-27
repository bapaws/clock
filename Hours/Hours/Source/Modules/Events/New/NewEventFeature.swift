//
//  NewEventFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift

@Reducer
struct NewEventFeature {
    @ObservableState
    struct State: Equatable {
        var event: EventEntity?

        var emoji: String = ""
        var title: String
        var hex: HexEntity
        var category: CategoryEntity?

        @Presents var selectCategory: SelectCategoryFeature.State?
        @Presents var colorPick: ColorPickFeature.State?

        var isLoading = false
        var createNameAttempts = 0
        var createCategoryAttempts = 0

        init(event: EventEntity? = nil, category: CategoryEntity? = nil) {
            self.event = event
            self.emoji = event?.emoji ?? ""
            self.title = event?.name ?? ""
            self.hex = event?.hex ?? .random
            self.category = category ?? event?.category
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case cancel
        case save
        case saveCompleted(EventEntity)

        case updateCalendarRecords(EventEntity)

        case selectCategoryTapped
        case selectCategory(PresentationAction<SelectCategoryFeature.Action>)

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
                    state.createNameAttempts += 1
                    return .none
                }

                guard let category = state.category else {
                    state.createCategoryAttempts += 1
                    return .none
                }

                state.isLoading = true
                return .run { [state] send in
                    if var event = state.event {
                        event.emoji = state.emoji
                        event.name = state.title
                        event.hex = state.hex
                        await AppRealm.shared.writeEvent(event, addTo: category)

                        await send(.updateCalendarRecords(event))
                        await send(.saveCompleted(event))
                    } else {
                        // 保存创建任务对象
                        var event = EventEntity(emoji: state.emoji, name: state.title, hex: state.hex)
                        await AppRealm.shared.writeEvent(event, addTo: category)
                        // 完成保存后，设置正确的 category，保证后面 Action 中数据正确
                        event.category = category

                        // 发送保存成功通知
                        await send(.saveCompleted(event))
                    }

                    await dismiss()
                }

            case .updateCalendarRecords(let entity):
                return .run { _ in
                    var event = entity
                    let items = await AppRealm.shared.getRecords(where: { $0.events._id == event._id })
                    event.items = items
                    await AppManager.shared.updateCalendarEvents(by: event)
                }

            case .selectCategoryTapped:
                state.selectCategory = SelectCategoryFeature.State(selectedCategory: state.category)
                return .none

            case .selectCategory(.presented(.didSelectedCategory(let entity))):
                state.category = entity
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
        .ifLet(\.$selectCategory, action: \.selectCategory) {
            SelectCategoryFeature()
        }
        .ifLet(\.$colorPick, action: \.colorPick) {
            ColorPickFeature()
        }
    }
}
