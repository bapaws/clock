//
//  TimelineItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/19.
//

import HoursShare
import SwiftUI

struct TimelineItemView: View {
    let index: Int
    let record: RecordObject
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing, spacing: 10) {
                Text(record.endAt.to(format: "HH:mm"))
                    .font(.body, weight: .regular)
                Text(record.startAt.to(format: "HH:mm"))
                    .font(.callout)
                    .foregroundStyle(Color.secondaryLabel)
            }
            .monospacedDigit()

            VStack {
                if index == 0 {
                    Image(systemName: "circle.circle")
                        .font(.title2)
                        .foregroundStyle(ui.primary)
                } else {
                    Circle()
                        .stroke(ui.primary, lineWidth: 2)
                        .frame(width: 15, height: 15)
                }
                if isLast {
                    Spacer()
                } else {
                    Rectangle()
                        .fill(ui.primary)
                        .frame(minWidth: 2, idealWidth: 2, maxWidth: 2, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .width(24)
            if let event = record.event {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        if let emoji = event.emoji {
                            Text(emoji)
                                .font(.headline, weight: .regular)
                        }
                        Text(event.name)
                            .font(.headline, weight: .regular)

                        Spacer()

                        Text(record.milliseconds.shortTimeLengthText)
                            .font(.callout)
                            .foregroundStyle(ui.secondaryLabel)
                    }
                    if let category = event.categorys.first {
                        CategoryView(category: category)
                    }
                }
                .padding()
                .background(ui.secondaryBackground)
                .cornerRadius(16)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    VStack {
        TimelineItemView(index: 0, record: RecordObject(creationMode: .enter, startAt: Date.now, milliseconds: 1000), isLast: false)
        TimelineItemView(index: 0, record: RecordObject(creationMode: .enter, startAt: Date.now, milliseconds: 1000), isLast: true)
    }
}
