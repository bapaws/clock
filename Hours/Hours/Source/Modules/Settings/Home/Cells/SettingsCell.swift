//
//  SettingsCell.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import SwiftUI
import SwiftUIX

struct SettingsCell<Content: View>: View {
    let title: String
    var isPro: Bool = false
    var content: () -> Content
    var body: some View {
        HStack(spacing: 2) {
            Text(title)
            if isPro {
                Image(systemName: "crown")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
            }
            Spacer()

            content()
        }
        .font(.body)
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsCell(title: "Title", isPro: true, content: { Text("") })
}
