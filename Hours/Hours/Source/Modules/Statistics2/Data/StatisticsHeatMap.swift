//
//  StatisticsHeatMap.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate

struct StatisticsHeatMap: Identifiable, Equatable {
    var id: Date { range.lowerBound }

    var range: Range<Date>
    var record: RecordEntity?
}

extension StatisticsHeatMap {
    static func random() -> [StatisticsHeatMap] {
        var heatMaps = [StatisticsHeatMap]()
        let startAt = Date().dateAtStartOf(.day)
        let entities = RecordEntity.random(count: 96)
        for index in 0 ... 95 {
            let endAt = startAt.addingTimeInterval(15 * 60)
            let range = startAt ..< endAt
            heatMaps.append(StatisticsHeatMap(range: range, record: entities[index]))
        }
        return heatMaps
    }
}

// MARK: -

protocol StatisticsHeatMapState {
    var records: [RecordEntity]? { get set }
    var startAt: Date { get }
    var endAt: Date { get }

    var heatMaps: [StatisticsHeatMap] { get set }
    var heatMapTimeInterval: TimeInterval { get }
}

// MARK: -

protocol StatisticsHeatMapReducer {
    func updateHeatMap<State: StatisticsHeatMapState>(state: inout State)
}

extension StatisticsHeatMapReducer {
    func updateHeatMap<State: StatisticsHeatMapState>(state: inout State) {
        state.heatMaps.removeAll(keepingCapacity: true)

        var startAt = state.startAt
        /// startAt 是这个时间段的开始时间
        /// endAt 是时间段的结束时间
        /// 所以这里求两个时间的距离，需要取结束时间的第二天的开始时间
        let endAt = state.endAt.dateAt(.tomorrowAtStart)
        let heatMapCount = Int(state.startAt.distance(to: endAt) / state.heatMapTimeInterval)
        for _ in 0 ..< heatMapCount {
            let endAt = startAt.addingTimeInterval(state.heatMapTimeInterval)
            let range = startAt ..< endAt
            let first = state.records?
                .filter {
                    ($0.startAt ..< $0.endAt).isIntersection(range)
                }
                .sorted {
                    let duration0 = ($0.startAt ..< $0.endAt).intersectionDuration(range)
                    let duration1 = ($1.startAt ..< $1.endAt).intersectionDuration(range)
                    return duration0 > duration1
                }
                .first
            state.heatMaps.append(StatisticsHeatMap(range: range, record: first))

            startAt = endAt
        }
    }
}
