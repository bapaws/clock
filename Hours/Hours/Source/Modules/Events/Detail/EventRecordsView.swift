//
//  EventRecordsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/4/10.
//

import HoursShare
import OrderedCollections
import RealmSwift
import SwiftUI

struct EventRecordsView: View {
    let records: OrderedDictionary<Date, [RecordEntity]>
    let onRecordTapped: (RecordEntity) -> Void
    let onRecordDeleted: (RecordEntity) -> Void

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
            ForEach(0 ..< records.count, id: \.self) { index in
                let (key, value) = records.elements[index]
                Section {
                    ForEach(value) { record in
                        EventRecordsItemView(record: record, onRecordDeleted: onRecordDeleted)
                            .onTapGesture {
                                onRecordTapped(record)
                            }
                    }
                } header: {
                    Text(key.toString(.date(.medium)))
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(ui.background)
                }
            }
        }
        .padding()
    }
}

#Preview {
    EventRecordsView(records: [.now: RecordEntity.random(count: 10)]) { _ in
    } onRecordDeleted: { _ in
    }
}
