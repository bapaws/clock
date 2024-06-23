//
//  MainView.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIIntrospect
import SwiftUIX

enum MainTabTag: Int, Identifiable {
    case events, records, statistics, settings
    var id: MainTabTag { self }
}

struct MainView: View {
    @Perception.Bindable var store: StoreOf<MainFeature>

    let ui: UIManager = .shared
    let app: AppManager = .shared

    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                TabView(selection: $store.selection) {
                    EventsHomeView(
                        store: store.scope(state: \.eventsHome, action: \.eventsHome)
                    )
                    .tag(MainTabTag.events)
                    .tabItem {
                        Image(image: R.image.events()!)
                    }

                    RecordsHomeView(
                        store: store.scope(state: \.recordsHome, action: \.recordsHome)
                    )
                    .tag(MainTabTag.records)
                    .tabItem {
                        Image(image: R.image.records()!)
                    }

                    StatisticsView(
                        store: store.scope(state: \.statistics, action: \.statistics)
                    )
                    .tag(MainTabTag.statistics)
                    .tabItem {
                        Image(image: R.image.statistics()!)
                    }

                    GeneralSettingsView(isPaywallPresented: $store.isPaywallPresented)
                        .tag(MainTabTag.settings)
                        .tabItem {
                            Image(image: R.image.settings()!)
                        }
                }
                .accentColor(ui.primary)
                .tint(ui.primary)
                .background(ui.background)
                .foregroundStyle(ui.label)
            }

            // MARK: Paywall

            .fullScreenCover(isPresented: $store.isPaywallPresented) {
                PaywallView()
            }
        }
        .environmentObject(ui)
        .environmentObject(app)
    }

    var navigationTitle: String {
        switch store.selection {
        case .events:
            R.string.localizable.events()
        case .records:
            R.string.localizable.records()
        case .statistics:
            R.string.localizable.statistics()
        case .settings:
            R.string.localizable.settings()
        }
    }
}

#Preview {
    MainView(
        store: .init(initialState: .init()) {
            MainFeature()
        }
    )
}
