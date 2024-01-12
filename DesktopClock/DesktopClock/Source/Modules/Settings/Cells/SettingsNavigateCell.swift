//
//  SettingsNavigateCell.swift
//  DesktopClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import SwiftUI

struct SettingsNavigateCell: View {
    let title: String
    var value: String? = nil
    var isPro: Bool = false
    let action: () -> Void

    @EnvironmentObject var ui: UIManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                Text(title)
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
            }
        }
        .softNavigateCellButtonStyle(padding: EdgeInsets(.horizontal, 16))
        .height(cellHeight)
    }
}

#Preview {
    VStack {
        SettingsNavigateCell(title: "Title", value: nil, isPro: true, action: {})
        SettingsNavigateCell(title: "Title", value: "value", isPro: false, action: {})
    }
}
