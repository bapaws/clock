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
    let records: [RecordEntity]

    var id: Date { date }
}

@Reducer
struct TimelinePageFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.recordsHomeCurrentState) var home = .init()

        var items: IdentifiedArrayOf<TimelinePageItem> = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case onRecordLoaded(Date)
        case updateRecords(Date, [RecordEntity])

        case cacheRecords(Date)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onRecordLoaded(let date):
                return .run { send in
                    let startOfDay = date.dateAtStartOf(.day)
                    let endOfDay = date.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords { $0.endAt >= startOfDay && $0.endAt <= endOfDay }
                    // 使用开始时间进行数据刷新
                    await send(.updateRecords(startOfDay, records), animation: .default)

                    // 缓存昨天和明天的数据
                    await send(.cacheRecords(date))
                }

            case .cacheRecords(let date):
                return .run { send in
                    let startOfYesterday = date.dateAt(.yesterdayAtStart)
                    let endOfYesterday = startOfYesterday.dateAt(.endOfDay)
                    let yesterdayRecords = await AppRealm.shared.getRecords { $0.endAt >= startOfYesterday && $0.endAt <= endOfYesterday }
                    // 使用开始时间进行数据刷新
                    await send(.updateRecords(startOfYesterday, yesterdayRecords))

                    let startOfTomorrow = date.dateAt(.tomorrowAtStart)
                    let endOfTomorrow = startOfTomorrow.dateAt(.endOfDay)
                    let tomorrowRecords = await AppRealm.shared.getRecords { $0.endAt >= startOfTomorrow && $0.endAt <= endOfTomorrow }
                    // 使用开始时间进行数据刷新
                    await send(.updateRecords(startOfTomorrow, tomorrowRecords))
                }

            case .updateRecords(let date, let entities):
                state.items[id: date] = TimelinePageItem(date: date, records: entities)
                return .none



            default:
                return .none
            }
        }
    }
}
