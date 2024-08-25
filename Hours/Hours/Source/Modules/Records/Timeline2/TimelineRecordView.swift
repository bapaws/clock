//
//  TimelineRecordView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/24.
//

import HoursShare
import SwiftUI
import SwiftUIX

struct TimelineRecordView: View {
    let record: RecordEntity
    var onTapped: (() -> Void)?
    var onDeleted: (() -> Void)?

    var onEventTapped: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .stroke(ui.primary, lineWidth: 2)

                Rectangle()
                    .fill(ui.primary)
                    .frame(width: 1)
            }
            .frame(width: 18)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    if let event = record.event {
                        VStack(alignment: .leading, spacing: 16) {
                            Button {
                                onEventTapped?()
                            } label: {
                                HStack {
                                    if let emoji = event.emoji, !emoji.isEmpty {
                                        Text(emoji)
                                    }
                                    Text(event.name)
                                }
                                .font(.title3, weight: .medium)
                            }

                            if let category = event.category {
                                CategoryView(category: category)
                            }

                            TimeRangeView(startAt: record.startAt, endAt: record.endAt)
                        }
                    }
                    Spacer()

                    StatisticsTimeView(
                        time: record.milliseconds.time,
                        numberFont: .title3,
                        numberWeight: .regular,
                        numberColor: ui.label,
                        spacing: 4
                    )
                }

                if let notes = record.notes, !notes.isEmpty {
                    Text(notes)
                        .lineLimit(1)
                        .font(.subheadline)
                        .foregroundStyle(ui.secondaryLabel)
                }
            }
            .padding()
            .foregroundStyle(ui.label)
            .background(ui.secondaryBackground)
            .cornerRadius(16)
            .contextMenu {
                Button {
                    onTapped?()
                } label: {
                    Label(L10n.edit, systemImage: "square.and.pencil")
                }

                Button(role: .destructive) {
                    onDeleted?()
                } label: {
                    Label(L10n.delete, systemImage: "trash")
                }
            }
            .cornerRadius(16)
            .contentShape(Rectangle())
            .onTapGesture {
                onTapped?()
            }
        }
    }
}

#Preview {
    TimelineRecordView(
        record: .random()
    )
}
