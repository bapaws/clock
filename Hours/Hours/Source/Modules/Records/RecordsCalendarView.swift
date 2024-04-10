//
//  RecordsCalendarView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/7.
//

import Foundation
import HoursShare
import PopupView
import SwiftDate
import SwiftUI
import SwiftUIX

struct RecordsCalendarView: View {
    @Binding var currentDate: Date
    @Binding var isNewRecordPresented: Bool

    @State private var isDatePickerPresented: Bool = false
    @State private var pickDate: Date

    let weekdaySymbols = DateFormatter().shortWeekdaySymbols!

    var today: Date { AppManager.shared.today }
    var initialDate: Date { AppManager.shared.initialDate }

    init(currentDate: Binding<Date>, isNewRecordPresented: Binding<Bool>) {
        self._currentDate = currentDate
        self._isNewRecordPresented = isNewRecordPresented

        self.pickDate = currentDate.wrappedValue
    }

    var body: some View {
        VStack(alignment: .leading) {
            let currentIsToday = currentDate.compare(toDate: today, granularity: .month) == .orderedSame

            HStack {
                Button(action: {
                    isDatePickerPresented = true
                }) {
                    HStack(spacing: 6) {
                        Text(currentDate.to(format: "yyyyMM"))
                            .font(.title)
                        Image(systemName: "chevron.right")
                            .font(.body)
                    }
                }
                Spacer()
                Button(action: {
                    isNewRecordPresented = true
                }) {
                    Image(systemName: "plus")
                        .padding(.leading)
                        .font(.title3)
                }
            }
            .foregroundStyle(ui.primary)
            .padding()

            GeometryReader { proxy in
                let itemWidth = (proxy.size.width) / CGFloat(weekdaySymbols.count)
                ScrollViewReader { scrollViewProxy in
                    // 当前月份的最后一天
                    // 如果当前月份是现在，最后一天就是现在，如果不是，取本月的最后一天
                    let monthDays = currentIsToday ? today.day : currentDate.monthDays
                    // 当前星期的 index
                    let endOfMonthWeekday = currentIsToday ? today.weekday - 1 : currentDate.dateAt(.endOfMonth).weekday
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(alignment: .top, spacing: 0) {
                            ForEach(1 ... monthDays, id: \.self) { day in
                                let isCurrent = currentDate.day == day
                                VStack(spacing: 2) {
                                    let weekdayIndex = (weekdaySymbols.count * 5 - monthDays + day + endOfMonthWeekday) % weekdaySymbols.count
                                    Text(weekdaySymbols[weekdayIndex])
                                        .font(.caption2)
                                    Text("\(day)")
                                        .font(.title3)
                                    if isCurrent {
                                        Circle()
                                            .fill(ui.primary)
                                            .frame(width: 4, height: 4)
                                    }
                                }
                                .foregroundStyle(isCurrent ? ui.primary : ui.secondaryLabel)
                                .width(itemWidth)
                                .onTapGesture {
                                    withAnimation {
                                        currentDate = currentDate.dateBySet([.day: day])!
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    .onAppear {
                        scrollViewProxy.scrollTo(monthDays, anchor: .bottom)
                    }
                    .onChange(of: currentDate) { newValue in
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue.day, anchor: .center)
                        }
                    }
                }
            }
        }
        .height(126)
        .sheet(isPresented: $isDatePickerPresented) {
            DatePicker("Enter", selection: $currentDate.animation(), in: initialDate...today, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
                .labelsHidden()
        }
    }
}

#Preview {
    RecordsCalendarView(currentDate: .constant(.init()), isNewRecordPresented: .constant(false))
}
