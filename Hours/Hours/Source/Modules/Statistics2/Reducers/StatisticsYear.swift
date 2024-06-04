//
//  StatisticsYear.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate

@Reducer
struct StatisticsYear: StatisticsOverallReducer, StatisticsTimeDistributionReducer, StatisticsContributionReducer {
    @ObservableState
    struct State: Equatable, StatisticsOverallState, StatisticsTimeDistributionState, StatisticsContributionYearState {
        var range: ClosedRange<Date>
        var isThisYear: Bool { range.lowerBound.compare(.isThisYear) }

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
        let timeDistributionComponent: Calendar.Component = .month

        // MARK: Contribution

        var contributions = [StatisticsContribution]()
        var contributionMaxMilliseconds: Int = -1
        var contributionMonths: [StatisticsContributionMonth] = []

        init() {
            @Dependency(\.date.now) var now
            self.range = now.dateAtStartOf(.year) ... now.dateAtEndOf(.year)
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
                    await withTaskGroup(of: Void.self) { group in
                        group.addTask { await send(.updateOverallDayComposition) }
                        group.addTask { await send(.updateTimeDistribution) }
                        group.addTask { await send(.updateContribution) }
                    }
                }

            case .updateOverallDayComposition:
                updateOverallComposition(state: &state)
                return .none

            case .updateTimeDistribution:
                updateTimeDistribution(state: &state)
                return .none

            case .updateContribution:
                updateYearContribution(state: &state)
                return .none

            case .previous:
                let lower = state.range.lowerBound.dateByAdding(-1, .year).date
                let upper = state.range.upperBound.dateByAdding(-1, .year).date
                state.range = lower ... upper

                // 显示 loading 状态
                state.records = nil
                state.totalCount = 0
                state.totalMilliseconds = 0
                return .run { send in
                    await send(.onAppear)
                }

            case .next:
                let lower = state.range.lowerBound.dateByAdding(1, .year).date
                let upper = state.range.upperBound.dateByAdding(1, .year).date
                state.range = lower ... upper

                // 显示 loading 状态
                state.records = nil
                state.totalCount = 0
                state.totalMilliseconds = 0

                return .run { send in
                    await send(.onAppear)
                }
            }
        }
    }
}
