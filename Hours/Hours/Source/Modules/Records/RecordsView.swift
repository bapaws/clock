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

    @EnvironmentObject var app: AppManager

    var today: Date { app.today }
    var initialDate: Date { app.initialDate }

    @State private var isDatePickerPresented: Bool = false

    @State private var selectedRecord: RecordObject?
    @State private var isNewRecordPresented: Bool = false

    var pageIndex: Binding<Int> {
        Binding<Int>(get: {
            currentDate.difference(in: .day, from: initialDate)!
        }, set: { newValue in
            currentDate = initialDate.dateByAdding(newValue, .day).date
        })
    }

    var body: some View {
        let pageCount = today.difference(in: .day, from: initialDate)!

        VStack(spacing: 0) {
            RecordsCalendarView(currentDate: $currentDate, isNewRecordPresented: $isNewRecordPresented)

            PaginationView(showsIndicators: false) {
                ForEach(0 ... pageCount, id: \.self) { index in
                    let date = today.dateByAdding(index - pageCount, .day).date
                    TimelineView(date: date, selectedRecord: $selectedRecord)
                }
            }
            .currentPageIndex(pageIndex)
        }
        .background(ui.background)
        .sheet(item: $selectedRecord) {
            presentNewRecord(for: $0)
        }
        .sheet(isPresented: $isNewRecordPresented) {
            presentNewRecord()
        }
        .sheet(isPresented: $isDatePickerPresented) {
            DatePicker("Enter", selection: $currentDate.animation(), in: initialDate ... today, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
                .labelsHidden()
        }
        .onChange(of: AppManager.shared.today) { newValue in
            currentDate = newValue
        }
    }

    // MARK: New Record

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

    func presentNewRecord(for record: RecordObject? = nil) -> some View {
        var newRecordView: NewRecordView
        if let record = record {
            newRecordView = NewRecordView(record: record)
        } else {
            newRecordView = NewRecordView(startAt: newRecordStartAt, endAt: newRecordEndAt)
        }

        let view = newRecordView
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .labelsHidden()
        if #available(iOS 16.4, *) {
            return view
                .presentationCornerRadius(32)
                .presentationContentInteraction(.scrolls)
        } else {
            return view
        }
    }
}

#Preview {
    RecordsView()
}
