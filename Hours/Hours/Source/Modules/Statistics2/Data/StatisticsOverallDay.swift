//
//  StatisticsOverallDay.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Foundation
import HoursShare
import IdentifiedCollections

struct StatisticsOverallDay: Identifiable, Equatable {
    var id: String { event.id }
    var event: EventEntity
    var totalCount: Int
    var totalMilliseconds: Int

    var startAngle: Double = 0
    var endAngle: Double = 0
}

// MARK: -

protocol StatisticsOverallState {
    var records: [RecordEntity]? { get set }
    var startAt: Date { get }
    var endAt: Date { get }

    var totalMilliseconds: Int { get }

    var compositions: IdentifiedArrayOf<StatisticsOverallDay> { get set }
    var isOverallDayExpanded: Bool { get set }
}

// MARK: -

protocol StatisticsOverallReducer {
    func updateOverallComposition<State: StatisticsOverallState>(state: inout State)
}

extension StatisticsOverallReducer {
    func updateOverallComposition<State: StatisticsOverallState>(state: inout State) {
        state.compositions.removeAll(keepingCapacity: true)
        guard let results = state.records else { return }

        var compositions = IdentifiedArrayOf<StatisticsOverallDay>()
        for result in results {
            guard let event = result.event, result.milliseconds != 0 else { continue }

            if var composition = compositions[id: event.id] {
                composition.totalCount += 1
                composition.totalMilliseconds += result.milliseconds
                compositions[id: event.id] = composition
            } else {
                compositions[id: event.id] = StatisticsOverallDay(event: event, totalCount: 1, totalMilliseconds: result.milliseconds)
            }
        }
        compositions.sort { $0.totalMilliseconds > $1.totalMilliseconds }

        var startAngle: Double = -90
        let angularInset: Double = 15
        var millisecondOfAngle = (360 - Double(compositions.count <= 1 ? 0 : compositions.count) * angularInset) / Double(state.totalMilliseconds)
        for index in 0 ..< compositions.count {
            compositions[index].startAngle = startAngle
            let endAngle = startAngle + Double(compositions[index].totalMilliseconds) * millisecondOfAngle
            compositions[index].endAngle = endAngle

            startAngle = endAngle + angularInset
        }
        state.compositions = compositions
    }
}
