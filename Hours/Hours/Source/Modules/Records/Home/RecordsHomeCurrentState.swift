//
//  RecordsHomeCurrentState.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/20.
//

import ComposableArchitecture
import Foundation
import HoursShare
import SwiftDate

struct RecordsHomeCurrentState: Equatable {
    var date: Date {
        didSet {
            previousDays = daysInWeek(for: date.dateByAdding(-7, .day).date)
            currentDays = daysInWeek(for: date)
            nextDays = daysInWeek(for: date.dateByAdding(7, .day).date)
        }
    }

    var previousDays: [Date] = []
    var currentDays: [Date] = []
    var nextDays: [Date] = []

    init() {
        @Dependency(\.date.now) var now
        let startOfDay = now.dateAtStartOf(.day)
        date = startOfDay

        previousDays = daysInWeek(for: startOfDay.dateByAdding(-7, .day).date)
        currentDays = daysInWeek(for: startOfDay)
        nextDays = daysInWeek(for: startOfDay.dateByAdding(7, .day).date)
    }

    private func daysInWeek(for date: Date) -> [Date] {
        var daysInCurrentWeek: [Date] = []
        let startOfWeek = date.dateAt(.startOfWeek)
        for index in 0 ..< 7 {
            let date: Date = startOfWeek.addingTimeInterval(TimeInterval(index) * 24 * 3600)
            daysInCurrentWeek.append(date)
        }
        return daysInCurrentWeek
    }
}

extension PersistenceReaderKey where Self == InMemoryKey<RecordsHomeCurrentState> {
    static var recordsHomeCurrentState: Self {
        inMemory("recordsHomeCurrentState")
    }
}
