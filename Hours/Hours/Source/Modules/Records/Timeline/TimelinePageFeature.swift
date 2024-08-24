//
//  TimelinePageFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/20.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift
import SwiftDate

struct TimelinePageItem: Identifiable, Equatable {
    let date: Date
    var records: [RecordEntity]

    var id: Date { date }
}

@Reducer
struct TimelinePageFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.recordsHomeCurrentState) var home = .init()

        var timelines: IdentifiedArrayOf<TimelineFeature.State> = []
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onRecordLoaded(Date?)
        case updateRecords(Date, [RecordEntity])

        case timelines(IdentifiedActionOf<TimelineFeature>)

        case onRecordTapped(RecordEntity?)

        case deleteRecord(RecordEntity)

        case cacheRecords(Date)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onRecordLoaded(let date):
                let date = (date ?? state.home.date).dateAt(.startOfDay)
                if state.timelines[id: date] == nil {
                    state.timelines.append(TimelineFeature.State(date: date))
                }

                let startOfYesterday = date.dateAt(.yesterdayAtStart)
                if state.timelines[id: startOfYesterday] == nil {
                    state.timelines.append(TimelineFeature.State(date: startOfYesterday))
                }

                let startOfTomorrow = date.dateAt(.tomorrowAtStart)
                if state.timelines[id: startOfTomorrow] == nil {
                    state.timelines.append(TimelineFeature.State(date: startOfTomorrow))
                }

                return .run { send in
                    await send(.timelines(.element(id: date, action: .onAppear)))
                    await send(.timelines(.element(id: startOfYesterday, action: .onAppear)))
                    await send(.timelines(.element(id: startOfTomorrow, action: .onAppear)))
                }

            default:
                return .none
            }
        }
        .forEach(\.timelines, action: \.timelines) {
            TimelineFeature()
        }
    }
}
