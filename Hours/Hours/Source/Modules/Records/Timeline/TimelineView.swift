//
//  TimelineView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/9.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

struct TimelineView: View {
    let records: [RecordEntity]?
    let onRecordTapped: (RecordEntity?) -> Void

    var body: some View {
        ScrollView {
            if let records, !records.isEmpty {
                LazyVStack(spacing: 0) {
                    ForEach(0 ..< records.count, id: \.self) { index in
                        let record = records[index]
                        TimelineItemView(index: index, record: record, isLast: index == records.count - 1)
                            .onTapGesture {
                                onRecordTapped(record)
                            }
                    }
                }
                .padding()
            } else {
                Image("NotFound")
                    .padding(.large)
                    .padding(.top, .large)
                    .onTapGesture {
                        onRecordTapped(nil)
                    }
            }
        }
    }
}

#Preview {
    TimelineView(
        records: [], onRecordTapped: { _ in }
    )
}
