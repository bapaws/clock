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
}

// MARK: -

protocol StatisticsOverallState {
    var records: [RecordEntity]? { get set }
    var startAt: Date { get }
    var endAt: Date { get }

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

        for result in results {
            guard let event = result.event else { continue }

            if var composition = state.compositions[id: event.id] {
                composition.totalCount += 1
                composition.totalMilliseconds += result.milliseconds
                state.compositions[id: event.id] = composition
            } else {
                state.compositions[id: event.id] = StatisticsOverallDay(event: event, totalCount: 1, totalMilliseconds: result.milliseconds)
            }
        }
        state.compositions.sort { $0.totalMilliseconds > $1.totalMilliseconds }
    }
}
