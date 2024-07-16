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
import UIKit

enum MainTabTag: Int, Identifiable {
    case events, records, statistics, settings
    var id: MainTabTag { self }
}

struct MainView: View {
    @Perception.Bindable var store: StoreOf<MainFeature>

    let didBecomeActive = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)

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
                        Image(asset: Asset.Tab.events)
                    }

                    RecordsHomeView(
                        store: store.scope(state: \.recordsHome, action: \.recordsHome)
                    )
                    .tag(MainTabTag.records)
                    .tabItem {
                        Image(asset: Asset.Tab.records)
                    }

                    StatisticsView(
                        store: store.scope(state: \.statistics, action: \.statistics)
                    )
                    .tag(MainTabTag.statistics)
                    .tabItem {
                        Image(asset: Asset.Tab.statistics)
                    }

                    GeneralSettingsView(isPaywallPresented: $store.isPaywallPresented)
                        .tag(MainTabTag.settings)
                        .tabItem {
                            Image(asset: Asset.Tab.settings)
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
            .onReceive(didBecomeActive) { _ in
                switch store.selection {
                case .events:
                    store.send(.eventsHome(.onAppear))

                case .records:
                    @Dependency(\.date.now) var now
                    store.send(.recordsHome(.timeline(.onRecordLoaded(now))))

                default:
                    break
                }
            }
        }
        .environmentObject(ui)
        .environmentObject(app)
    }

    var navigationTitle: String {
        switch store.selection {
        case .events:
            L10n.events
        case .records:
            L10n.records
        case .statistics:
            L10n.statistics
        case .settings:
            L10n.settings
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
