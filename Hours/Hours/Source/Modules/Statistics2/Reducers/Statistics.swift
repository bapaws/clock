//
//  Statistics.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/31.
//

import ComposableArchitecture
import Foundation
import SwiftDate

@Reducer
struct Statistics {
    @ObservableState
    struct State: Equatable {
        enum PageIndex: Int, CaseIterable, CustomStringConvertible, Identifiable {
            case day, week, month, year

            var id: Self { self }

            var description: String {
                switch self {
                case .day:
                    R.string.localizable.day()
                case .week:
                    R.string.localizable.week()
                case .month:
                    R.string.localizable.month()
                case .year:
                    R.string.localizable.year()
                }
            }
        }

        var pageIndex: PageIndex = .day
        var currentPageIndex: Int = 0

        var day: StatisticsDay.State = .init()
        var week: StatisticsWeek.State = .init()
        var month: StatisticsMonth.State = .init()
        var year: StatisticsYear.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case day(StatisticsDay.Action)
        case week(StatisticsWeek.Action)
        case month(StatisticsMonth.Action)
        case year(StatisticsYear.Action)
        case onPageIndexChanged(Int)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Scope(state: \.day, action: \.day) {
            StatisticsDay()
        }
        Scope(state: \.week, action: \.week) {
            StatisticsWeek()
        }
        Scope(state: \.month, action: \.month) {
            StatisticsMonth()
        }
        Scope(state: \.year, action: \.year) {
            StatisticsYear()
        }

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onPageIndexChanged(let index):
                state.pageIndex = State.PageIndex(rawValue: index) ?? .day
                return .none
            default:
                return .none
            }
        }
    }
}
