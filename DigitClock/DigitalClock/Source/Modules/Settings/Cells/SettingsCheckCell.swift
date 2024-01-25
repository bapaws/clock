//
//  SettingsCheckCell.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import DigitalClockShare
import SwiftUI

struct SettingsCheckCell: View {
    let title: String
    var isPro: Bool = false

    @State var isChecked: Bool
    let action: () -> Void

    @EnvironmentObject var ui: UIManager

    var body: some View {
        Button(action: {
            isChecked = true
            action()
        }) {
            HStack(spacing: 2) {
                Text(title)
                if isPro {
                    Image(systemName: "crown")
                        .font(.subheadline, weight: .regular)
                        .foregroundColor(ui.colors.secondary)
                }
            }
        }
        .font(.system(.body, design: .rounded), weight: .ultraLight)
        .buttonStyle(CheckButtonStyle(checked: isChecked))
        .padding(.horizontal)
        .height(cellHeight)
    }

    struct CheckButtonStyle: ButtonStyle {
        let checked: Bool

        func makeBody(configuration: Self.Configuration) -> some View {
            HStack {
                configuration.label
                Spacer()
                if checked || configuration.isPressed {
                    Image(systemName: "checkmark")
                        .foregroundColor(UIManager.shared.colors.primary)
                        .frame(width: 32, height: 32)
                }
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    SettingsCheckCell(title: "Title", isPro: true, isChecked: false, action: {})
        .environmentObject(UIManager.shared)
}
