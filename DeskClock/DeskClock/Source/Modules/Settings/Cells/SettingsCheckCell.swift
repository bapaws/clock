//
//  SettingsCheckCell.swift
//  DeskClock
//
//  Created by 张敏超 on 2024/1/1.
//

import ClockShare
import DeskClockShare
import SwiftUI

struct SettingsCheckCell: View {
    let title: String
    var isPro: Bool = false

    @State var isChecked: Bool
//    @Binding var isChecked: Bool
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
                        .font(.subheadline)
                        .foregroundColor(ui.colors.secondary)
                }
            }
        }
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
                        .background(Color.Neumorphic.main)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Neumorphic.main)
                        .frame(width: 32, height: 32)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 16))
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
