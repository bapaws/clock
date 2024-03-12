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
                    .fill(event.color)
                    .frame(width: 4)
                Text(event.name)
                    .font(.title3)
                    .foregroundStyle(Color(white: 0.2))
            }
            .padding(.leading)
            .padding(.vertical)

            Spacer()

            if let action = playAction {
                Button(action: { action(event) }) {
                    Image(systemName: "play.fill")
                        .font(.system(.title3, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.small)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(event.color)
                        }
                }
            }
        }
        .padding(.trailing)
        .background(Color.tertiarySystemBackground)
        .cornerRadius(16)
    }
}

#Preview {
    EventItemView(event: EventObject(emoji: "👌", name: "Programing", category: CategoryObject(hex: HexObject(hex: "#DBEAB3"), emoji: "💰", name: "Work"), hex: HexObject(hex: "#757573")))
}
