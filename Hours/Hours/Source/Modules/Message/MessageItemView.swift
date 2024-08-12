//
//  MessageItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/7.
//

import ComposableArchitecture
import HoursShare
import SwiftUI

struct MessageItemView: View {
    let item: MessageItem
    let close: () -> Void
    var body: some View {
        HStack(alignment: .center) {
            Text(item.emoji)
            Text(item.title)
                .font(.footnote)
                .foregroundStyle(ui.label)
            Spacer()
            Button {} label: {
                Image(systemName: "xmark")
                    .font(.footnote)
                    .foregroundStyle(Color.placeholderText)
            }
        }
        .padding(.small)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
        .padding()
    }
}

#Preview {
    MessageItemView(
        item: .init(
            id: 0,
            emoji: "✉️",
            title: "App Store 五🌟好评，可获得包月会员～"
        ),
        close: {}
    )
    .background(Color.systemGray6)
}
