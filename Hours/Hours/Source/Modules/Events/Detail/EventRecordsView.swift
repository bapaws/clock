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
    @ObservedRealmObject var event: EventObject

    @Binding var editRecord: RecordObject?

    private var results: SectionedResults<String, RecordObject>

    init(event: EventObject, editRecord: Binding<RecordObject?>) {
        self.event = event
        _editRecord = editRecord

        // 当事件被删除时，这里的 event 是无效的，执行 setioned 方法会导致崩溃
        // 所以事件删除，先返回主页，再删除
        results = event.items.sectioned(
            by: { $0.endAt.toString(.date(.medium)) },
            sortDescriptors: [SortDescriptor(keyPath: \RecordObject.endAt, ascending: false)]
        )
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
            ForEach(results) { result in
                Section {
                    ForEach(result) { record in
                        EventRecordsItemView(record: record)
                            .onTapGesture {
                                editRecord = record
                            }
                    }
                } header: {
                    Text(result.key)
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
    EventRecordsView(event: EventObject(), editRecord: .constant(RecordObject()))
}
