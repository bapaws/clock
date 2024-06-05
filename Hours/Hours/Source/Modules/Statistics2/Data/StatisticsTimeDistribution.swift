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
    let records: [RecordEntity]
    let duration: TimeInterval

    var totalHours: Double { duration / 3600 }
    var totalMinutes: Double { duration / 60 }
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
        state.timeDistributions.removeAll(keepingCapacity: true)
        guard let results = state.records else { return }

        var startAt = state.startAt
        while startAt < state.endAt {
            let endAt = startAt.dateByAdding(state.timeDistributionStep, state.timeDistributionComponent).date
            let range = startAt ..< endAt
            let records = results.filter { ($0.startAt ..< $0.endAt).isIntersection(range) }
            let duration = records.reduce(0) {
                $0 + ($1.startAt ..< $1.endAt).intersectionDuration(range)
            }
            let distribution = StatisticsTimeDistribution(range: range, records: records, duration: duration)
            state.timeDistributions.append(distribution)

            startAt = endAt
        }
    }
}
