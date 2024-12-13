//
//  SettingsHomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/24.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import PopupView
import RevenueCat
import SwiftUI
import SwiftUIX

@Reducer
struct GeneralSettingsFeature {
    @ObservableState
    struct State: Equatable {
        var isDarkModePresented: Bool = false
        var isLandspaceModePresented: Bool = false
        var isAppIconPresented: Bool = false

        // MARK: Other

        var isOnboardingPresented = false
        var isAboutPresented = false
        var isFeedbackPresented = false

        @Presents var activityList: ActivityListFeature.State?
        @Presents var widget: SettingsWidgetTabFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case onDarkModeTapped
        case onLandspaceModeTapped
        case onAppIconTapped

        case onOnboardingTapped
        case onActivityTapped
        case onAboutTapped
        case onFeedbackTapped

        case onActivityListTapped
        case activityList(PresentationAction<ActivityListFeature.Action>)

        case onWidgetTapped
        case widget(PresentationAction<SettingsWidgetTabFeature.Action>)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onWidgetTapped:
                state.widget = .init()
                return .none

            case .onDarkModeTapped:
                state.isDarkModePresented.toggle()
                return .none
            case .onLandspaceModeTapped:
                state.isLandspaceModePresented.toggle()
                return .none
            case .onAppIconTapped:
                state.isAppIconPresented.toggle()
                return .none
            case .onOnboardingTapped:
                state.isOnboardingPresented.toggle()
                return .none
            case .onActivityTapped:
                state.activityList = .init()
                return .none
            case .onAboutTapped:
                state.isAboutPresented.toggle()
                return .none
            case .onFeedbackTapped:
                state.isFeedbackPresented.toggle()
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$activityList, action: \.activityList) {
            ActivityListFeature()
        }
        .ifLet(\.$widget, action: \.widget) {
            SettingsWidgetTabFeature()
        }
    }
}

struct SettingsHomeView: View {
    // MARK: Paywall

    @Binding var isPaywallPresented: Bool

    @EnvironmentObject var ui: UIManager
    @Environment(\.colorScheme) var colorScheme

    @Perception.Bindable var store: StoreOf<GeneralSettingsFeature>

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(L10n.settings)
                scrollView
            }
            .background(ui.background)

            // MARK: Other

            .sheet(isPresented: $store.isOnboardingPresented) {
                let indices = app.isHealthAvailable ? OnboardingIndices.allCases : [.welcome, .appScreenTime, .calendar, .health]
                OnboardingView(onboardingIndices: indices) {
                    // 这里调用 dimiss 没有用
                    // @Environment(\.dismiss) private var dismiss
                    // 只在需要 dimiss 的页面有效
                    // dismiss()
                    // 这里穿空的闭包，在 OnboardingView 里执行了 dimiss()
                }
            }
            .sheet(isPresented: $store.isAboutPresented) {
                AboutView()
            }
            .sheet(isPresented: $store.isFeedbackPresented) {
                FeedbackView()
            }
            .sheet(item: $store.scope(state: \.activityList, action: \.activityList)) {
                ActivityListView(store: $0)
            }
            .sheet(item: $store.scope(state: \.widget, action: \.widget)) {
                SettingsWidgetTabView(store: $0)
            }
        }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack {
                SettingsPaywallView {
                    if ProManager.default.isLifetime { return }
                    isPaywallPresented = true
                }
                SettingsSection(title: L10n.widget) {
                    SettingsNavigateCell(title: L10n.widget) {
                        store.send(.onWidgetTapped)
                    }
                }

                SettingsRecordSection(isPaywallPresented: $isPaywallPresented)

                // MARK: Appearance

                SettingsGeneralSection()

                // MARK: Other

                SettingsSection(title: L10n.other) {
                    SettingsNavigateCell(title: L10n.onboarding) {
                        store.send(.onOnboardingTapped)
                    }
                    if !ProManager.default.isPro {
                        SettingsNavigateCell(title: L10n.activities) {
                            store.send(.onActivityTapped)
                        }
                    }

                    SettingsNavigateCell(title: L10n.rate, action: goToRate)
                    SettingsNavigateCell(title: L10n.feedback) {
                        store.send(.onFeedbackTapped)
                    }
                    SettingsNavigateCell(title: L10n.about) {
                        store.send(.onAboutTapped)
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
    }

    func goToRate() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id6479001202?action=write-review")!)
    }
}

#Preview {
    SettingsHomeView(
        isPaywallPresented: .constant(false),
        store: StoreOf<GeneralSettingsFeature>.init(
            initialState: .init(),
            reducer: { GeneralSettingsFeature() }
        )
    )
}
