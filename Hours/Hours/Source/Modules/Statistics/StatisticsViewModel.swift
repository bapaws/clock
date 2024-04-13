//
//  StatisticsViewModel.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/14.
//

import Foundation
import HoursShare
import RealmSwift
import SwiftUI

// MARK: StatisticsDailyType

public enum StatisticsType: CaseIterable, Identifiable {
    case task, category

    public var id: StatisticsType { self }

    var title: String {
        switch self {
        case .task:
            R.string.localizable.event()
        case .category:
            R.string.localizable.category()
        }
    }
}

// MARK: StatisticsBarType

public enum StatisticsBarType: Identifiable, CaseIterable {
    case last7Days, weekly, monthly, yearly

    public var id: StatisticsBarType { self }

    var title: String {
        switch self {
        case .last7Days:
            R.string.localizable.last7Days()
        case .weekly:
            R.string.localizable.weekly()
        case .monthly:
            R.string.localizable.monthly()
        case .yearly:
            R.string.localizable.yearly()
        }
    }
}

// MARK: StatisticsBarValue

public struct StatisticsBarValue: Identifiable {
    public var index: Int
    public var type: StatisticsBarType
    public var date: Date
    public var eventName: String
    public var milliseconds: Int
    public var color: Color

    public var id: Date { date }
    public var hours: Double { Double(milliseconds) / 1000 / 60 / 60 }

    var title: String {
        switch type {
        case .last7Days:
            date.to(format: "dd")
        case .weekly:
            R.string.localizable.weekNum(date.weekOfYear)
        case .monthly:
            date.to(format: "MM")
        case .yearly:
            date.to(format: "yyyy")
        }
    }
}

// MARK: StatisticsTimeDistributionType

public enum StatisticsTimeDistributionType: CaseIterable, Identifiable {
    case all, year, month, week

    public var id: StatisticsTimeDistributionType { self }

    var title: String {
        switch self {
        case .all:
            R.string.localizable.all()
        case .year:
            R.string.localizable.year()
        case .month:
            R.string.localizable.month()
        case .week:
            R.string.localizable.week()
        }
    }
}

// MARK: StatisticsViewModel

public class StatisticsViewModel: ObservableObject {
    @Published var totalRecords: Int
    @Published var totalMilliseconds: Int

    @Published public var dailyType: StatisticsType = .task

    // MARK: Daily

    @Published public var dailyDate: Date = AppManager.shared.today
    @Published public var dailyTotalMilliseconds: Int = 0

    @Published var dailyEvents: [EventObject] = []
    @Published var dailyEventMilliseconds: [Int] = []

    @Published var dailyCategorys: [CategoryObject] = []
    @Published var dailyCategoryMilliseconds: [Int] = []

    // MARK: Bar

    @Published public var barSelection: StatisticsBarType = .last7Days {
        willSet { onBarSelectionWillChange(newValue) }
    }

    @Published public var barValues: [StatisticsBarValue] = []

    // MARK: Time Distribution

    @Published public var distributionType: StatisticsTimeDistributionType = .all {
        willSet { onDistributionTypeWillChange(newValue) }
    }

    @Published public var distributionEvents: [EventObject] = []
    @Published public var distributionEventMilliseconds: [Int] = []
    @Published public var distributionYearlyDate: Date = AppManager.shared.today
    @Published public var distributionMonthlyDate: Date = AppManager.shared.today
    @Published public var distributionWeeklyDate: Date = AppManager.shared.today

    // MARK: Realm

    private var token: NotificationToken?
    private var records: Results<RecordObject>
    var realm: Realm {
        DBManager.default.realm
    }

    init() {
        records = DBManager.default.records
        totalRecords = records.count
        totalMilliseconds = records.sum(of: \.milliseconds)

        // TODO: 性能问题修复
        let today = AppManager.shared.today
        onDailyDateChanged(today)
        onBarSelectionWillChange(.last7Days)

        onDistributionTypeWillChange(.all)

        token = records.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial(let collectionType):
                print(collectionType)
            case .update:
                self.onDailyDateChanged(self.dailyDate)
                self.onBarSelectionWillChange(self.barSelection)
            case .error(let error):
                print(error)
            }
        }
    }

    deinit {
        token?.invalidate()
    }

    func onDailyDateChanged(_ newValue: Date) {
        dailyDate = newValue.dateAtStartOf(.day)

        dailyTotalMilliseconds = 0
        dailyEvents.removeAll()
        dailyEventMilliseconds.removeAll()
        dailyCategorys.removeAll()
        dailyCategoryMilliseconds.removeAll()

        let tomorrow = dailyDate.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "startAt >= %@ AND startAt < %@", dailyDate as NSDate, tomorrow as NSDate)
        let results = records.filter(predicate)

        for record in results {
            dailyTotalMilliseconds += record.milliseconds

            guard let event = record.event else { continue }
            if let index = dailyEvents.firstIndex(of: event) {
                dailyEventMilliseconds[index] += record.milliseconds
            } else {
                dailyEvents.append(event)
                dailyEventMilliseconds.append(record.milliseconds)
            }

            guard let category = event.categorys.first else { continue }
            if let index = dailyCategorys.firstIndex(of: category) {
                dailyCategoryMilliseconds[index] += record.milliseconds
            } else {
                dailyCategorys.append(category)
                dailyCategoryMilliseconds.append(record.milliseconds)
            }
        }
    }

    func onBarSelectionWillChange(_ newValue: StatisticsBarType) {
        barValues.removeAll()

        let today = AppManager.shared.today
        var startAt: Date
        var endAt: Date

        for index in 0 ... 6 {
            switch newValue {
            case .last7Days:
                startAt = today.dateByAdding(-index, .day).date
                endAt = startAt.dateAtEndOf(.day)
            case .weekly:
                startAt = today.dateByAdding(-index, .weekdayOrdinal).date
                endAt = startAt.dateAtEndOf(.weekdayOrdinal)
            case .monthly:
                startAt = today.dateByAdding(-index, .month).date
                endAt = startAt.dateAtEndOf(.month)
            case .yearly:
                startAt = today.dateByAdding(-index, .year).date
                endAt = startAt.dateAtEndOf(.year)
            }

            let predicate = NSPredicate(format: "startAt >= %@ AND startAt <= %@", startAt as NSDate, endAt as NSDate)
            let results: Results<RecordObject> = records.filter(predicate)
            if results.isEmpty {
                let value = StatisticsBarValue(index: index, type: newValue, date: startAt, eventName: "", milliseconds: 0, color: UIManager.shared.primary)
                barValues.append(value)
                continue
            }

            for record in results {
                guard let event = record.event else { continue }

                if let index = barValues.firstIndex(where: { $0.eventName == event.name && $0.date == startAt }) {
                    barValues[index].milliseconds += record.milliseconds
                } else {
                    let value = StatisticsBarValue(index: index, type: newValue, date: startAt, eventName: event.name, milliseconds: record.milliseconds, color: event.darkPrimary)
                    barValues.append(value)
                }
            }
        }
    }

    func onDistributionTypeWillChange(_ newValue: StatisticsTimeDistributionType) {
        distributionEvents.removeAll()
        distributionEventMilliseconds.removeAll()

        var results: Results<RecordObject>
        switch newValue {
        case .all:
            results = realm.objects(RecordObject.self)
        case .year:
            let startAt = distributionYearlyDate.dateAtStartOf(.year) as NSDate
            let endAt = distributionYearlyDate.dateAtEndOf(.year) as NSDate
            let predicate = NSPredicate(format: "startAt >= %@ AND startAt <= %@", startAt, endAt)
            results = realm.objects(RecordObject.self).filter(predicate)
        case .month:
            let startAt = distributionMonthlyDate.dateAtStartOf(.month) as NSDate
            let endAt = distributionMonthlyDate.dateAtEndOf(.month) as NSDate
            let predicate = NSPredicate(format: "startAt >= %@ AND startAt <= %@", startAt, endAt)
            results = realm.objects(RecordObject.self).filter(predicate)
        case .week:
            let startAt = distributionWeeklyDate.dateAtStartOf(.weekdayOrdinal) as NSDate
            let endAt = distributionWeeklyDate.dateAtEndOf(.weekdayOrdinal) as NSDate
            let predicate = NSPredicate(format: "startAt >= %@ AND startAt <= %@", startAt, endAt)
            results = realm.objects(RecordObject.self).filter(predicate)
        }

        for record in results {
            guard let event = record.event else { continue }

            if let index = distributionEvents.firstIndex(of: event) {
                distributionEventMilliseconds[index] += record.milliseconds
            } else {
                distributionEvents.append(event)
                distributionEventMilliseconds.append(record.milliseconds)
            }
        }
    }
}
