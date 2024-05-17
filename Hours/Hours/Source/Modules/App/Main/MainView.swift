//
//  MainView.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import ClockShare
import HoursShare
import SwiftUI
import SwiftUIIntrospect
import SwiftUIX

enum MainTabTag: Int, Identifiable {
    case events, records, statistics, settings
    var id: MainTabTag { self }
}

struct MainView: View {
    @StateObject var ui: UIManager = .shared
    @StateObject var app: AppManager = .shared

    @State private var selectionValue: MainTabTag = .events

    // MARK: Paywall

    @State var isPaywallPresented: Bool

    init(isPaywallPresented: Bool = false) {
        self._isPaywallPresented = .init(initialValue: isPaywallPresented)
    }

    var body: some View {
        TabView(selection: $selectionValue) {
            NavigationStack {
                EventsHomeView()
            }
            .tag(MainTabTag.events)
            .tabItem {
                Image(image: R.image.events()!)
            }

            RecordsView()
                .tag(MainTabTag.records)
                .tabItem {
                    Image(image: R.image.records()!)
                }

            NavigationStack {
                StatisticsView()
            }
            .tag(MainTabTag.statistics)
            .tabItem {
                Image(image: R.image.statistics()!)
            }

            NavigationStack {
                GeneralSettingsView(isPaywallPresented: $isPaywallPresented)
            }
            .tag(MainTabTag.settings)
            .tabItem {
                Image(image: R.image.settings()!)
            }
        }
        .accentColor(ui.primary)
        .tint(ui.primary)
        .background(ui.background)
        .foregroundStyle(ui.label)
        .environmentObject(ui)
        .environmentObject(app)

        // MARK: Paywall

        .fullScreenCover(isPresented: $isPaywallPresented) {
            PaywallView()
        }
    }

    var navigationTitle: String {
        switch selectionValue {
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
    MainView()
}
