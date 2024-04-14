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
    @State private var selectionValue: MainTabTag = .events

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
                GeneralSettingsView()
            }
            .tag(MainTabTag.settings)
            .tabItem {
                Image(image: R.image.settings()!)
            }
        }

        .accentColor(ui.primary)
        .tint(ui.primary)
        .background(ui.colors.background)
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
