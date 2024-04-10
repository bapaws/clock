//
//  RecordsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/10.
//

import ClockShare
import Dependencies
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct RecordsView: View {
    @State var currentDate: Date = AppManager.shared.today

    var today: Date { AppManager.shared.today }
    var initialDate: Date { AppManager.shared.initialDate }

    @State private var isDatePickerPresented: Bool = false
    @State private var isNewRecordPresented: Bool = false

    var pageIndex: Binding<Int> {
        Binding<Int>(get: {
            currentDate.difference(in: .day, from: initialDate)!
        }, set: { newValue in
            currentDate = initialDate.dateByAdding(newValue, .day).date
        })
    }

    var newRecordStartAt: Date {
        let date = DBManager.default.getRecordEndAt(for: currentDate)
        return date ?? currentDate.dateBySet(hour: 9, min: 0, secs: 0)!
    }

    var newRecordEndAt: Date {
        let startAt = newRecordStartAt
        var endAt = startAt.addingTimeInterval(3600)
        if currentDate.compare(.isSameDay(today)) {
            endAt = Date.now < startAt ? startAt.addingTimeInterval(3600) : Date.now
        }
        return endAt
    }

    var body: some View {
        let pageCount = today.difference(in: .day, from: initialDate)!
        NavigationStack {
            VStack(spacing: 0) {
                RecordsCalendarView(currentDate: $currentDate, isNewRecordPresented: $isNewRecordPresented)

                PaginationView(showsIndicators: false) {
                    ForEach(0 ... pageCount, id: \.self) { index in
                        let date = today.dateByAdding(index - pageCount, .day).date
                        TimelineView(date: date)
                    }
                }
                .currentPageIndex(pageIndex)
            }
            .background(ui.background)
        }
        .background(ui.background)
        .sheet(isPresented: $isNewRecordPresented) {
            let view = NewRecordView(startAt: newRecordStartAt, endAt: newRecordEndAt, isPresented: $isNewRecordPresented)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .labelsHidden()
            if #available(iOS 16.4, *) {
                view
                    .presentationCornerRadius(32)
                    .presentationContentInteraction(.scrolls)
            } else {
                view
            }
        }
        .sheet(isPresented: $isDatePickerPresented) {
            DatePicker("Enter", selection: $currentDate.animation(), in: initialDate...today, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
                .labelsHidden()
        }
        .onChange(of: AppManager.shared.today) { newValue in
            currentDate = newValue
        }
    }
}

#Preview {
    RecordsView()
}
