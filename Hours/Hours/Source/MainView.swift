//
//  MainView.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import ClockShare
import HoursShare
import SwiftUI

enum MainTabTag: Identifiable {
    case events, records, statistics, settings
    var id: MainTabTag { self }
}

struct MainView: View {
    @State var selctionValue: MainTabTag = .events

    var body: some View {
        TabView(selection: $selctionValue) {
            EventsHomeView()
                .tag(MainTabTag.events)
                .tabItem {
                    Image(image: R.image.events()!)
                }

            RecordsView()
                .tag(MainTabTag.records)
                .tabItem {
                    Image(image: R.image.records()!)
                }

            StatisticsView()
                .tag(MainTabTag.statistics)
                .tabItem {
                    Image(image: R.image.statistics()!)
                }

            GeneralSettingsView()
                .tag(MainTabTag.settings)
                .tabItem {
                    Image(image: R.image.settings()!)
                }
        }
        .accentColor(ui.primary)
        .tint(ui.primary)
        .background(ui.colors.background)
    }
}

#Preview {
    MainView()
}
