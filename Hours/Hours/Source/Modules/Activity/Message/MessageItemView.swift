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
    let onClosed: () -> Void
    let onTapped: () -> Void
    var body: some View {
        HStack(alignment: .center) {
            Text(item.emoji)
            Text(item.title)
                .foregroundStyle(ui.label)
            Spacer()
            Button(action: onClosed) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.placeholderText)
                    .padding(.extraSmall)
            }
        }
        .font(.callout)
        .animation(.bouncy, value: item)
        .contentTransition(.numericText())
        .padding(.small)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
        .padding()
        .onTapGesture(perform: onTapped)
    }
}

#Preview {
    MessageItemView(
        item: .init(
            id: 0,
            emoji: "✉️",
            title: "App Store 五🌟好评，可获得包月会员～"
        ),
        onClosed: {},
        onTapped: {}
    )
    .background(Color.systemGray6)
}
