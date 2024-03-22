//
//  NewItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import SwiftUI

struct NewItemView<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        HStack {
            Text(title)
                .font(.body, weight: .bold)
            Spacer()

            content()
        }
        .multilineTextAlignment(.trailing)
        .height(24)
        .padding()
        .padding(.horizontal, .small)
        .background(.tertiarySystemBackground)
        .cornerRadius(16)
    }
}

#Preview {
    NewItemView(title: "Title") {
        Text("Hello")
    }
}
