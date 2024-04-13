//
//  EventRecordsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/4/10.
//

import HoursShare
import RealmSwift
import SwiftUI

struct EventRecordsView: View {
    let event: EventObject

    private var results: SectionedResults<String, RecordObject>

    init(event: EventObject) {
        self.event = event

        results = event.items.sectioned(
            by: { $0.endAt.toString(.date(.medium)) },
            sortDescriptors: [SortDescriptor(keyPath: \RecordObject.endAt, ascending: false)]
        )
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(results) { result in
                Text(result.key)
                    .padding(.vertical)

                ForEach(result) {
                    EventRecordsItemView(record: $0)
                        .onTapGesture {
                            
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    EventRecordsView(event: EventObject())
}
