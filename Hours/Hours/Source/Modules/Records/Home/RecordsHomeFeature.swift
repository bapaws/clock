//
//  RecordsHomeFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift
import SwiftDate

@Reducer
struct RecordsHomeFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.recordsHomeCurrentState) var home = RecordsHomeCurrentState()

        var calendar: CalendarHeaderPageFeature.State
        var timeline: TimelinePageFeature.State

        @Presents var newRecord: NewRecordFeature.State?

        init() {
            calendar = .init()
            timeline = .init()
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case calendar(CalendarHeaderPageFeature.Action)
        case timeline(TimelinePageFeature.Action)

        case onNewRecordTapped(RecordEntity?)
        case updateNewRecordState(NewRecordFeature.State)
        case newRecord(PresentationAction<NewRecordFeature.Action>)
    }

    @Dependency(\.date.now) var now

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.calendar, action: \.calendar) {
            CalendarHeaderPageFeature()
        }
        Scope(state: \.timeline, action: \.timeline) {
            TimelinePageFeature()
        }

        Reduce { state, action in
            switch action {
            case .onNewRecordTapped(let entity):
                return .run { [currentDate = state.home.date] send in
                    if let entity {
                        let state = NewRecordFeature.State(record: entity)
                        await send(.updateNewRecordState(state))
                        return
                    }

                    let startOfDay = currentDate.dateAtStartOf(.day)
                    let endOfDay = currentDate.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords(where: { $0.endAt >= startOfDay && $0.endAt <= endOfDay })

                    var startAt: Date
                    if let endAt = records.first?.endAt {
                        startAt = endAt
                    } else if currentDate.compare(.isSameDay(now)) {
                        startAt = now.addingTimeInterval(-3600)
                    } else {
                        startAt = startOfDay.dateBySet([.hour: 9]) ?? startOfDay
                    }
                    let endAt = startAt.addingTimeInterval(3600)
                    let state = NewRecordFeature.State(startAt: startAt, endAt: endAt)
                    await send(.updateNewRecordState(state))
                }

            case .updateNewRecordState(let newRecordState):
                state.newRecord = newRecordState
                return .none

            case .newRecord(.presented(.saveCompleted(let entity))):
                return .run { send in
                    // 如果同一天，则更新当天的数据，如果不是直接更新两天的数据
                    await send(.timeline(.onRecordLoaded(entity.endAt)))
                }

            default:
                return .none
            }
        }
        .ifLet(\.$newRecord, action: \.newRecord) {
            NewRecordFeature()
        }
    }
}
