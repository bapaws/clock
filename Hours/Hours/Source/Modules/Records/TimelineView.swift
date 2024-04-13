//
//  TimelineView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/9.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct TimelineView: View {
    @ObservedResults(RecordObject.self, sortDescriptor: SortDescriptor(keyPath: \RecordObject.endAt, ascending: false))
    var records

    @Binding var selectedRecord: RecordObject?

    init(date: Date, selectedRecord: Binding<RecordObject?>) {
        self._selectedRecord = selectedRecord

        let startOfDay = date.dateAtStartOf(.day)
        let tomorrow = date.dateAt(.tomorrowAtStart)
        let predicate = NSPredicate(format: "endAt >= %@ AND endAt < %@", startOfDay as NSDate, tomorrow as NSDate)
        $records.filter = predicate
    }

    var body: some View {
        ScrollViewReader { _ in
            ScrollView {
                if records.isEmpty {
                    Image("NotFound")
                        .padding(.large)
                        .padding(.top, .large)
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(0 ..< records.count, id: \.self) { index in
                            let record = records[index]
                            TimelineItemView(index: index, record: record, isLast: index == records.count - 1)
                                .onTapGesture {
                                    selectedRecord = record
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    TimelineView(date: Date(), selectedRecord: Binding<RecordObject?>.constant(nil))
}
