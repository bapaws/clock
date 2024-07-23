//
//  TimelinePageView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/20.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate
import SwiftUI

struct TimelinePageView: View {
    @Perception.Bindable var store: StoreOf<TimelinePageFeature>

    var body: some View {
        WithPerceptionTracking {
            InfinitePageView(
                selection: $store.home.date,
                backward: { $0.dateAt(.yesterdayAtStart) },
                forward: { $0.dateAt(.tomorrowAtStart) }
            ) { date in
                WithPerceptionTracking {
                    TimelineView(
                        records: store.items[id: date]?.records,
                        onRecordTapped: { store.send(.onRecordTapped($0)) },
                        onRecordDeleted: { store.send(.deleteRecord($0), animation: .default) }
                    )
                }
            }
            .onAppear {
                store.send(.onRecordLoaded(store.home.date))
            }
            .onChange(of: store.home.date) { _ in }
        }
    }
}
