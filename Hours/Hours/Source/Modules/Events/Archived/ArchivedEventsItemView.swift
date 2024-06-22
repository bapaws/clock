//
//  ArchivedEventsItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/11.
//

import Foundation
import HoursShare
import SwiftUI

struct ArchivedEventsItemView: View {
    let event: EventEntity
    let unarchiveEvent: (EventEntity) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(event.primary)
                        .frame(width: 4)
                    Text(event.name)
                        .font(.body, weight: .regular)
                }

                if let archivedAt = event.archivedAt {
                    let date = archivedAt.toString(.dateTimeMixed(dateStyle: .medium, timeStyle: .short))
                    Text(R.string.localizable.archivedAt(date))
                        .font(.callout)
                        .foregroundStyle(ui.secondaryLabel)
                }
            }
            .padding(.leading)
            .padding(.vertical)

            Spacer()

            Button {
                unarchiveEvent(event)
            } label: {
                Text(R.string.localizable.unarchive())
                    .font(.callout)
                    .padding(.small)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ui.primary, lineWidth: 1)
                    }
            }
        }
        .padding(.trailing)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}
