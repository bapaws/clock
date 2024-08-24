//
//  TimelinePageView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/20.
//

import ClockShare
import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate
import SwiftUI
import SwiftUIX

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
                    let timelineStore = store.scope(state: \.timelines, action: \.timelines)
                        .scope(state: \.[id: date], action: \.[id: date])
                    IfLetStore(timelineStore) { store in
                        TimelineView(store: store)
                    } `else`: {
                        NotFoundView()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.send(.onRecordTapped(nil))
                            }
                    }
                }
            }
            .onAppear {
                store.send(.onRecordLoaded(store.home.date))
            }
        }
    }
}
