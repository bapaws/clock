//
//  SettingsTagView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/16.
//

import SwiftUI

let newTagTitle = "NEW"

struct SettingsTagView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.footnote, weight: .bold)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background(ui.primary.opacity(0.5))
            .cornerRadius(6)
            .foregroundStyle(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke()
                    .foregroundStyle(ui.primary)
            }
//            .padding(.horizontal, 2)
    }
}

#Preview {
    SettingsTagView(title: "NEW")
}
