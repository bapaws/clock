//
//  StatisticsContribution.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Foundation
import HoursShare
import SwiftDate

struct StatisticsContribution: Identifiable, Equatable {
    var id: Date { range.lowerBound }

    var range: Range<Date>
    var totalMilliseconds: Int?
}

/// 贡献图顶部的月份，symbol 为空时不显示，按周排列
struct StatisticsContributionMonth: Identifiable, Equatable {
    var id: Date { range.lowerBound }

    var range: Range<Date>
    var symbol: String?
}

// MARK: -

protocol StatisticsContributionState {
    var records: [RecordEntity]? { get set }
    var startAt: Date { get }
    var endAt: Date { get }

    var contributions: [StatisticsContribution] { get set }
    var contributionTimeInterval: TimeInterval { get }
    var contributionMaxMilliseconds: Int { get set }
}

extension StatisticsContributionState {
    var contributionTimeInterval: TimeInterval { 24 * 3600 }
}

// MARK: -

protocol StatisticsContributionYearState: StatisticsContributionState {
    var contributionMonths: [StatisticsContributionMonth] { get set }
}

// MARK: -

protocol StatisticsContributionReducer {
    func updateYearContribution<State: StatisticsContributionYearState>(state: inout State)
    func updateMonthContribution<State: StatisticsContributionState>(state: inout State)
}

extension StatisticsContributionReducer {
    func updateYearContribution<State: StatisticsContributionYearState>(state: inout State) {
        state.contributions.removeAll(keepingCapacity: true)
        state.contributionMonths.removeAll(keepingCapacity: true)

        guard let results = state.records else { return }

        var startAt = state.startAt.dateAtStartOf(.year).dateAt(.startOfWeek)
        // 最后时刻
        let endAt = state.endAt.dateAt(.endOfWeek)

        var month = StatisticsContributionMonth(range: startAt.dateAt(.prevWeek) ..< startAt)
        while startAt < endAt {
            // 第二天的开始时间
            let endAt = startAt.addingTimeInterval(24 * 3600)
            let range = startAt ..< endAt

            let isThisYear = startAt >= state.startAt && startAt <= state.endAt
            if startAt >= month.range.upperBound {
                let nextWeek = startAt.dateAt(.nextWeek)
                let endOfWeek = startAt.dateAt(.endOfWeek)

                var symbol: String?
                // 结束的时间是否今年
                let isSameYear = endOfWeek.year == state.startAt.year
                if isSameYear, startAt.month != month.range.lowerBound.month || startAt.month != endOfWeek.month {
                    symbol = SwiftDate.defaultRegion.calendar.shortMonthSymbols[endOfWeek.month - 1]
                }
                // 避免重复添加
                if symbol == month.symbol {
                    symbol = nil
                }

                // 当上一列与当前这一列相同时，不显示
                month = StatisticsContributionMonth(
                    range: startAt ..< nextWeek,
                    symbol: symbol
                )
                state.contributionMonths.append(month)
            }

            // 设置下次循环的开始时间
            startAt = endAt

            if !isThisYear {
                state.contributions.append(StatisticsContribution(range: range))
                continue
            }

            let milliseconds = results.filter {
                ($0.startAt ..< $0.endAt).isIntersection(range)
            }
            .reduce(0) { $0 + $1.milliseconds }
            state.contributions.append(StatisticsContribution(range: range, totalMilliseconds: milliseconds))

            state.contributionMaxMilliseconds = max(state.contributionMaxMilliseconds, milliseconds)
        }
    }

    func updateMonthContribution<State: StatisticsContributionState>(state: inout State) {
        guard let results = state.records, !results.isEmpty else { return }
        state.contributions.removeAll(keepingCapacity: true)

        var startAt = state.startAt.dateAt(.startOfWeek)
        // 最后时刻
        let endAt = state.endAt.dateAt(.endOfWeek)

        while startAt < endAt {
            // 第二天的开始时间
            let endAt = startAt.addingTimeInterval(24 * 3600)
            let range = startAt ..< endAt

            let isThisMonth = startAt >= state.startAt && startAt <= state.endAt
            debugPrint("startAt: \(startAt), endAt: \(endAt)")

            // 设置下次循环的开始时间
            startAt = endAt

            if !isThisMonth {
                state.contributions.append(StatisticsContribution(range: range))
                continue
            }

            let milliseconds = results.filter {
                ($0.startAt ..< $0.endAt).isIntersection(range)
            }
            .reduce(0) { $0 + $1.milliseconds }
            state.contributions.append(StatisticsContribution(range: range, totalMilliseconds: milliseconds))

            state.contributionMaxMilliseconds = max(state.contributionMaxMilliseconds, milliseconds)
        }
    }
}
