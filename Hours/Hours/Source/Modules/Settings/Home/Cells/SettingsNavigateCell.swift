//
//  SettingsNavigateCell.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import HoursShare
import SwiftUI

struct SettingsNavigateCell: View {
    let title: String
    var value: String? = nil
    var tag: String?
    var isPro: Bool = false
    let action: () -> Void

    @EnvironmentObject var ui: UIManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                if let tag {
                    SettingsTagView(title: tag)
                        .padding(.leading, 4)
                }
                if isPro {
                    Image(systemName: "crown")
                        .font(.subheadline)
                        .foregroundColor(ui.colors.secondary)
                }
                Spacer()
                if let value = value {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.tertiaryLabel)
                }
                Image(systemName: "chevron.forward")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
            }
            .padding(horizontal: .regular, vertical: .small)
            .height(cellHeight)
        }
        .font(.body)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        SettingsNavigateCell(title: "Title", value: nil, isPro: true, action: {})
        SettingsNavigateCell(title: "Title", value: "value", isPro: false, action: {})
    }
}
