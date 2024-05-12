//
//  EventItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/6.
//

import HoursShare
import SwiftUI

struct EventItemView: View {
    var event: EventObject
    var playAction: ((EventObject) -> Void)?

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(event.primary)
                    .frame(width: 4)
                if let emoji = event.emoji {
                    Text(emoji)
                        .padding(.small)
                }
                Text(event.name)
                    .font(.body, weight: .regular)
            }
            .padding(.leading)
            .padding(.vertical)

            Spacer()

            if let action = playAction {
                Button(action: { action(event) }) {
                    Image(systemName: "play.fill")
                        .font(.system(.callout, design: .rounded))
                        .foregroundStyle(event.primary)
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(event.primaryContainer)
                        }
                }
            }
        }
        .padding(.trailing)
        .frame(height: cellHeight)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    EventItemView(event: EventObject(emoji: "👌", name: "Programing", hex: HexObject(hex: "#757573")))
}
