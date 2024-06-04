//
//  StatisticsTimeDistribution.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Foundation
import HoursShare
import IdentifiedCollections

struct StatisticsTimeDistribution: Identifiable, Equatable {
    var id: Date { range.lowerBound }

    let range: Range<Date>
    let duration: TimeInterval

    var totalHours: Double { duration / 3600 }
    var totalMinutes: Double { duration / 60 }

    init(range: Range<Date>, duration: TimeInterval) {
        self.range = range
        self.duration = duration
    }
}

// MARK: -

protocol StatisticsTimeDistributionState {
    var records: [RecordEntity]? { get set }
    var startAt: Date { get }
    var endAt: Date { get }

    var timeDistributions: IdentifiedArrayOf<StatisticsTimeDistribution> { get set }
    var timeDistributionStep: Int { get }
    var timeDistributionComponent: Calendar.Component { get }
}

extension StatisticsTimeDistributionState {
    var timeDistributionStep: Int { 1 }
}

// MARK: -

protocol StatisticsTimeDistributionReducer {
    func updateTimeDistribution<State: StatisticsTimeDistributionState>(state: inout State)
}

extension StatisticsTimeDistributionReducer {
    func updateTimeDistribution<State: StatisticsTimeDistributionState>(state: inout State) {
        guard let results = state.records else { return }

        state.timeDistributions.removeAll(keepingCapacity: true)
        var startAt = state.startAt
        while startAt < state.endAt {
            let endAt = startAt.dateByAdding(state.timeDistributionStep, state.timeDistributionComponent).date
            let range = startAt ..< endAt
            let duration = results.reduce(0) {
                let duration = ($1.startAt ..< $1.endAt).intersectionDuration(range)
                return $0 + (duration > 0 ? duration : 0)
            }
            state.timeDistributions.append(StatisticsTimeDistribution(range: range, duration: duration))

            startAt = endAt
        }
    }
}
