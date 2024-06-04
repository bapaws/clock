//
//  StatisticsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

struct StatisticsView: View {
    @Perception.Bindable var store: StoreOf<Statistics>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(R.string.localizable.statistics())
                StatisticsPageBar(Statistics.State.PageIndex.allCases, selection: $store.pageIndex.animation()) {
                    if store.pageIndex == $0 {
                        Text("\($0)")
                            .foregroundStyle(ui.label)
                            .font(.title3)
                    } else {
                        Text("\($0)")
                            .foregroundStyle(ui.secondaryLabel)
                            .font(.title3)
                    }
                }

                TabView(selection: $store.pageIndex.animation()) {
                    StatisticsDayView(store: store.scope(state: \.day, action: \.day))
                        .tag(Statistics.State.PageIndex.day)

                    StatisticsWeekView(store: store.scope(state: \.week, action: \.week))
                        .tag(Statistics.State.PageIndex.week)

                    StatisticsMonthView(store: store.scope(state: \.month, action: \.month))
                        .tag(Statistics.State.PageIndex.month)

                    StatisticsYearView(store: store.scope(state: \.year, action: \.year))
                        .tag(Statistics.State.PageIndex.year)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(ui.background)
        }
    }
}

#Preview {
    StatisticsView(store: StoreManager.default.store)
}
