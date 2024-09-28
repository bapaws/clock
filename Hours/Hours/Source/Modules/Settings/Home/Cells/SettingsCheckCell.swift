//
//  SettingsCheckCell.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import HoursShare
import SwiftUI

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
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
        .contentShape(Rectangle())
    }
}

struct SettingsCheckCell: View {
    var icon: String?
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
            HStack(spacing: 8) {
                Text(title)
                if let icon = icon {
                    Image(systemName: icon)
                }
                if isPro {
                    Image(systemName: "crown")
                        .font(.subheadline, weight: .regular)
                        .foregroundColor(ui.colors.secondary)
                }
            }
        }
        .font(.body)
        .buttonStyle(CheckButtonStyle(checked: isChecked))
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsCheckCell(title: "Title", isPro: true, isChecked: false, action: {})
        .environmentObject(UIManager.shared)
}
