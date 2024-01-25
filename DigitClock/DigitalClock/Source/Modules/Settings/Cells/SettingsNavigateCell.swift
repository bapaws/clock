//
//  SettingsNavigateCell.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import DigitalClockShare
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
                Image(systemName: "chevron.forward")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
                    .padding(.leading, .extraSmall)
            }
        }
        .font(.system(.body, design: .rounded), weight: .ultraLight)
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
    }
}

#Preview {
    VStack {
        SettingsNavigateCell(title: "Title", value: nil, isPro: true, action: {})
        SettingsNavigateCell(title: "Title", value: "value", isPro: false, action: {})
    }
}
