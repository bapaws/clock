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
    var event: EventEntity

    @Binding var editRecord: RecordEntity?

    @State private var results: OrderedDictionary<String, [RecordEntity]> = [:]

    init(event: EventEntity, editRecord: Binding<RecordEntity?>) {
        self.event = event
        _editRecord = editRecord

        // 当事件被删除时，这里的 event 是无效的，执行 setioned 方法会导致崩溃
        // 所以事件删除，先返回主页，再删除
//        results = event.items.sectioned(
//            by: { $0.endAt.toString(.date(.medium)) },
//            sortDescriptors: [SortDescriptor(keyPath: \RecordObject.endAt, ascending: false)]
//        )
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
            ForEach(0 ..< results.count, id: \.self) { index in
                let (key, value) = results.elements[index]
                Section {
                    ForEach(value) { record in
                        EventRecordsItemView(record: record)
                            .onTapGesture {
                                editRecord = record
                            }
                    }
                } header: {
                    Text(key)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(ui.background)
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                results = await AppRealm.shared.sectionedRecords(event, by: { $0.endAt.toString(.date(.medium)) })
            }
        }
    }
}

#Preview {
    EventRecordsView(event: EventEntity.random(), editRecord: .constant(RecordEntity.random()))
}
