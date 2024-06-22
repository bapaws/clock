//
//  CalendarHeaderView.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import HoursShare
import SwiftDate
import SwiftUI

@Reducer
struct CalendarHeaderFeature {
    @ObservableState
    struct State: Equatable {
        var currentDate: Date
        var isNewRecordPresented: Bool = false

//        @State private var isDatePickerPresented: Bool = false
//        @State private var pickDate: Date

        var daysInCurrentWeek: [Date]

        init(currentDate: Date) {
            self.currentDate = currentDate

            var daysInCurrentWeek: [Date] = []
            let startOfWeek = currentDate.dateAtStartOf(.weekday)
            for index in 0 ..< 7 {
                let date: Date = startOfWeek.addingTimeInterval(TimeInterval(index) * 24 * 3600)
                daysInCurrentWeek.append(date)
            }
            self.daysInCurrentWeek = daysInCurrentWeek
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case onCurrentDateChanged(Date)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onCurrentDateChanged(let date):
                state.currentDate = date

                state.daysInCurrentWeek.removeAll()
                let startOfWeek = state.currentDate.dateAtStartOf(.weekday)
                for index in 0 ..< 7 {
                    let date: Date = startOfWeek.addingTimeInterval(TimeInterval(index) * 24 * 3600)
                    state.daysInCurrentWeek.append(date)
                }

                return .none

            default:
                return .none
            }
        }
    }
}

struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    let days: [Date]

    let weekdaySymbols = DateFormatter().shortWeekdaySymbols!

    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .top, spacing: 0) {
                ForEach(days, id: \.self) { date in
                    let isCurrent = currentDate == date
                    VStack(spacing: 2) {
                        Text(weekdaySymbols[date.weekday - 1])
                            .font(.caption2)
                        Text("\(date.day)")
                            .font(.title3)
                        if isCurrent {
                            Circle()
                                .fill(ui.primary)
                                .frame(width: 4, height: 4)
                        }
                    }
                    .foregroundStyle(isCurrent ? ui.primary : ui.secondaryLabel)
                    .onTapGesture {
                        currentDate = date
                    }
                }
                .width(proxy.size.width / CGFloat(days.count))
            }
        }
    }
}

#Preview {
    CalendarHeaderView(
        currentDate: .constant(.now),
        days: []
    )
}
