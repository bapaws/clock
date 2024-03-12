//
//  MainView.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import ClockShare
import SwiftUI

enum MainTabTag: Identifiable {
    case events, records, statistics, settings
    var id: MainTabTag { self }
}

struct MainView: View {
    @State var selctionValue: MainTabTag = .records
    @State var navigationTitle: String = R.string.localizable.tasks()

    var body: some View {
        TabView(selection: $selctionValue) {
            EventsView()
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

            Text("Hello World!")
                .tag(MainTabTag.settings)
                .tabItem {
                    Image(image: R.image.settings()!)
                }
        }
        .accentColor(Color(hexadecimal6: 0x8D6E63))
        .tint(Color(hexadecimal6: 0x8D6E63))
        .navigationTitle(navigationTitle)
        .onChange(of: selctionValue) { newValue in
            switch newValue {
            case .events:
                navigationTitle = R.string.localizable.tasks()
            case .records:
                navigationTitle = R.string.localizable.records()
            case .statistics:
                navigationTitle = R.string.localizable.statistics()
            case .settings:
                navigationTitle = R.string.localizable.settings()
            }
        }
    }
}

#Preview {
    MainView()
}
