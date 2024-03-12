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
    @State var currentDate: Date = Date().dateAtStartOf(.day)

    var today: Date { AppManager.shared.today }
    var startAt: Date { AppManager.shared.startAt }

    @State var isNewRecordPresented: Bool = false

    var body: some View {
        let pageCount = Int(startAt.getInterval(toDate: today, component: .day))
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Color.systemBackground.height(proxy.safeAreaInsets.top)

                RecordsCalendarView(currentDate: $currentDate, isNewRecordPresented: $isNewRecordPresented)
                    .background(Color.systemBackground)
                    .clipShape(.rect(bottomLeadingRadius: 32, bottomTrailingRadius: 32))

                TabView(selection: $currentDate.animation()) {
                    ForEach(0 ... pageCount, id: \.self) { index in
                        let date = today.dateByAdding(index - pageCount, .day).date
//                        let records = DBManager.default.getRecords(for: date)
                        TimelineView(date: date)
                            .tag(date)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .ignoresSafeArea(.container, edges: .top)
        }
        .background(Color.secondarySystemBackground)
        .sheet(isPresented: $isNewRecordPresented) {
            let date = DBManager.default.getRecordEndAt(for: currentDate)
            let startAt = date ?? currentDate.dateBySet(hour: 9, min: 0, secs: 0)!
            let endAt = currentDate == today ? Date() : startAt.addingTimeInterval(3600)
            if #available(iOS 16.4, *) {
                NewRecordView(startAt: startAt, endAt: endAt, isPresented: $isNewRecordPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(32)
                    .presentationContentInteraction(.scrolls)
                    .labelsHidden()
            } else {
                NewRecordView(startAt: startAt, endAt: endAt, isPresented: $isNewRecordPresented)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    RecordsView()
}
