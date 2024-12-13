//
//  WidgetFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/12/10.
//

import ComposableArchitecture

@Reducer
struct SettingsWidgetTabFeature {
    @ObservableState
    struct State: Equatable {
        enum PageIndex: Int, CaseIterable, CustomStringConvertible, Identifiable {
            case medium, large

            var id: Self { self }

            var description: String {
                switch self {
                case .medium:
                    L10n.medium
                case .large:
                    L10n.large
                }
            }
        }

        var pageIndex: PageIndex = .medium

        var medium: SettingsWidgetFeature.State = .init(family: .systemMedium)
        var large: SettingsWidgetFeature.State = .init(family: .systemLarge)
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case medium(SettingsWidgetFeature.Action)
        case large(SettingsWidgetFeature.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.medium, action: \.medium) {
            SettingsWidgetFeature()
        }
        Scope(state: \.large, action: \.large) {
            SettingsWidgetFeature()
        }

        Reduce { _, action in
            switch action {
            case .onAppear:
                return .none
            default:
                return .none
            }
        }
    }
}
