//
//  StatisticsDay.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift
import SwiftDate

@Reducer
struct StatisticsDay: StatisticsOverallReducer, StatisticsTimeDistributionReducer, StatisticsHeatMapReducer {
    @ObservableState
    struct State: Equatable, StatisticsOverallState, StatisticsTimeDistributionState, StatisticsHeatMapState {
        // MARK: Range

        var range: ClosedRange<Date>
        var isToday: Bool { range.lowerBound.compare(.isToday) }
        var isYesterday: Bool { range.lowerBound.compare(.isYesterday) }

        var startAt: Date { range.lowerBound }
        var endAt: Date { range.upperBound }

        var isPro: Bool = false

        // MARK: Records

        var records: [RecordEntity]?
        var totalCount: Int = 0
        var totalMilliseconds: Int = 0

        // MARK: HeatMap

        var heatMaps = [StatisticsHeatMap]()
        let heatMapTimeInterval: TimeInterval = 15 * 60

        // MARK: Overall Day Composition

        var compositions = IdentifiedArrayOf<StatisticsOverallDay>()
        var isOverallDayExpanded = false

        // MARK: TimeDistribution

        var timeDistributions = IdentifiedArrayOf<StatisticsTimeDistribution>()
        let timeDistributionComponent: Calendar.Component = .hour

        init() {
            @Dependency(\.date.now) var now
            self.range = now.dateAtStartOf(.day) ... now.dateAtEndOf(.day)
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onAppear

        case onRecordsChanged([RecordEntity])
        case updateOverallDayComposition
        case updateTimeDistribution
        case updateHeatMap

        case expandOverallDay

        case previous
        case next
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                // 数据量小，这里无需将 state.records 设置为 nil，让界面进入 loading 状态
                // 刷新肉眼几乎不可见
                return .run { [startAt = state.startAt, endAt = state.endAt] send in
                    let realm = try await StatisticsDailyRealm()
                    let results = await realm.getRecordEntitiesEndAt(from: startAt, to: endAt)
                    await send(.onRecordsChanged(results))
                }

            case .onRecordsChanged(let results):
                state.records = results
                state.totalCount = results.count
                state.totalMilliseconds = results.reduce(0) { $0 + $1.milliseconds }

                return .run { send in
                    await send(.updateOverallDayComposition)
                    await send(.updateTimeDistribution)
                    await send(.updateHeatMap)
                }

            case .updateOverallDayComposition:
                updateOverallComposition(state: &state)
                return .none

            case .updateTimeDistribution:
                updateTimeDistribution(state: &state)
                return .none

            case .updateHeatMap:
                updateHeatMap(state: &state)
                return .none

            case .expandOverallDay:
                state.isOverallDayExpanded.toggle()
                return .none

            case .previous:
                let lower = state.range.lowerBound.dateByAdding(-1, .day).date
                let upper = state.range.upperBound.dateByAdding(-1, .day).date
                state.range = lower ... upper

                state.isPro = !lower.isToday && !lower.isYesterday

                return .run { send in
                    await send(.onAppear)
                }

            case .next:
                let lower = state.range.lowerBound.dateByAdding(1, .day).date
                let upper = state.range.upperBound.dateByAdding(1, .day).date
                state.range = lower ... upper
                return .run { send in
                    await send(.onAppear)
                }
            }
        }
    }
}
