//
//  StatisticsMonth.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate

@Reducer
struct StatisticsMonth: StatisticsOverallReducer, StatisticsTimeDistributionReducer, StatisticsContributionReducer {
    @ObservableState
    struct State: Equatable, StatisticsOverallState, StatisticsTimeDistributionState, StatisticsContributionState {
        var range: ClosedRange<Date>
        var isThisMonth: Bool { range.lowerBound.compare(.isThisMonth) }

        var startAt: Date { range.lowerBound }
        var endAt: Date { range.upperBound }

        // MARK: Records

        var records: [RecordEntity]?
        var totalCount: Int = 0
        var totalMilliseconds: Int = 0

        // MARK: Overall Day Composition

        var compositions = IdentifiedArrayOf<StatisticsOverallDay>()
        var isOverallDayExpanded = false

        // MARK: TimeDistribution

        var timeDistributions = IdentifiedArrayOf<StatisticsTimeDistribution>()
        let timeDistributionComponent: Calendar.Component = .day

        // MARK: Contribution

        var contributions = [StatisticsContribution]()
        var contributionMaxMilliseconds: Int = -1

        init() {
            @Dependency(\.date.now) var now
            self.range = now.dateAt(.startOfMonth) ... now.dateAt(.endOfMonth)
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onAppear

        case onRecordsChanged([RecordEntity])
        case updateOverallDayComposition
        case updateTimeDistribution
        case updateContribution

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
                // 数据量不小也不是特别大，经过测试也无需设置 state.records = nil
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
                    await send(.updateContribution)
                }

            case .updateOverallDayComposition:
                updateOverallComposition(state: &state)
                return .none

            case .updateTimeDistribution:
                updateTimeDistribution(state: &state)
                return .none

            case .updateContribution:
                updateMonthContribution(state: &state)
                return .none

            case .previous:
                let lower = state.range.lowerBound.dateByAdding(-1, .month).date
                let upper = state.range.upperBound.dateByAdding(-1, .month).date
                state.range = lower ... upper
                return .run { send in
                    await send(.onAppear)
                }

            case .next:
                let lower = state.range.lowerBound.dateByAdding(1, .month).date
                let upper = state.range.upperBound.dateByAdding(1, .month).date
                state.range = lower ... upper
                return .run { send in
                    await send(.onAppear)
                }
            }
        }
    }
}