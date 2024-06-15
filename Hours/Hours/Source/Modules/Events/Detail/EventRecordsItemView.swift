//
//  EventRecordsItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/4/10.
//

import SwiftUI
import HoursShare

struct EventRecordsItemView: View {
    let record: RecordEntity

    var body: some View {
        HStack(alignment: .top) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(ui.primary)
                    .frame(minWidth: 2, idealWidth: 2, maxWidth: 2, minHeight: 0, maxHeight: .infinity, alignment: .center)

                Circle()
                    .fill(ui.primary)
                    .frame(width: 12, height: 12)

                Rectangle()
                    .fill(ui.primary)
                    .frame(minWidth: 2, idealWidth: 2, maxWidth: 2, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
            .width(24)

            VStack {
                HStack {
                    Text(record.startAt.to(format: "HH:mm") + "~" +  record.endAt.to(format: "HH:mm"))
                    Spacer()
                    Text(record.milliseconds.timeLengthText)
                        .font(.callout)
                        .foregroundStyle(ui.secondaryLabel)
                }
            }
            .padding()
            .background(ui.secondaryBackground)
            .cornerRadius(16)
            .padding(.vertical, .small)
        }
    }
}

#Preview {
    EventRecordsItemView(record: RecordEntity.random())
}
