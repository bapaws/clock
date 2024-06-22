//
//  StatisticsWeek.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate

@Reducer
struct StatisticsWeek: StatisticsOverallReducer, StatisticsTimeDistributionReducer, StatisticsHeatMapReducer {
    @ObservableState
    struct State: Equatable, StatisticsOverallState, StatisticsTimeDistributionState, StatisticsHeatMapState {
        var range: ClosedRange<Date>
        var isThisWeek: Bool { range.lowerBound.compare(.isThisWeek) }

        var startAt: Date { range.lowerBound }
        var endAt: Date { range.upperBound }

        // MARK: Records

        var records: [RecordEntity]?
        var totalCount: Int = 0
        var totalMilliseconds: Int = 0

        // MARK: HeatMap

        var heatMaps = [StatisticsHeatMap]()
        let heatMapTimeInterval: TimeInterval = 2 * 3600

        // MARK: Overall Day Composition

        var compositions = IdentifiedArrayOf<StatisticsOverallDay>()
        var isOverallDayExpanded = false

        // MARK: TimeDistribution

        var timeDistributions = IdentifiedArrayOf<StatisticsTimeDistribution>()
        let timeDistributionComponent: Calendar.Component = .day

        init() {
            @Dependency(\.date.now) var now
            self.range = now.dateAt(.startOfWeek) ... now.dateAt(.endOfWeek)
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onAppear

        case onRecordsChanged([RecordEntity])
        case updateOverallDayComposition
        case updateTimeDistribution
        case updateHeatMap

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
                    let results = await AppRealm.shared.getRecordsEndAt(from: startAt, to: endAt)
                    await send(.onRecordsChanged(results), animation: .default)
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

            case .previous:
                let lower = state.range.lowerBound.dateByAdding(-7, .day).date
                let upper = state.range.upperBound.dateByAdding(-7, .day).date
                state.range = lower ... upper
                return .run { send in
                    await send(.onAppear)
                }

            case .next:
                let lower = state.range.lowerBound.dateByAdding(7, .day).date
                let upper = state.range.upperBound.dateByAdding(7, .day).date
                state.range = lower ... upper
                return .run { send in
                    await send(.onAppear)
                }
            }
        }
    }
}
