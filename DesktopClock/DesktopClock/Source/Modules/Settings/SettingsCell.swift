//
//  SettingsCell.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/25.
//

import Neumorphic
import SwiftUI
import SwiftUIX

public struct SettingsCell: View {
    public static let height: CGFloat = 64

    @State public var item: SettingsItem
    @State private var isOn: Bool

    @EnvironmentObject var ui: UIManager

    init(item: SettingsItem) {
        self.item = item
        if case .toggle(_, let bool) = item.type {
            self.isOn = bool
        } else {
            self.isOn = false
        }
    }

    public var body: some View {
        switch item.type {
        case .toggle(let title, _):
            HStack(spacing: 2) {
                Text(title)
                if item.isPro {
                    Image(systemName: "crown")
                        .font(.subheadline)
                        .foregroundColor(Color.systemOrange)
                }
                Spacer()
                Toggle(title, isOn: $isOn)
                    .softSettingsSwitchToggleStyle(color: ui.color)
                    .frame(width: 64, height: 32)
            }
            .padding(horizontal: .regular, vertical: .small)
            .height(SettingsCell.height)
            .onChange(of: isOn) { _ in
                item.action?()
            }
        case .popup(let title, let string):
            Button(action: item.action!) {
                HStack(spacing: 2) {
                    Text(title)
                    if item.isPro {
                        Image(systemName: "crown")
                            .font(.subheadline)
                            .foregroundColor(Color.systemOrange)
                    }
                    Spacer()
                    if let value = string {
                        Text(value)
                            .font(.subheadline)
                            .foregroundColor(.tertiaryLabel)
                    }
                }
            }
            .softNavigateCellButtonStyle(padding: EdgeInsets(.horizontal, 16), color: ui.color)
            .height(SettingsCell.height)
        case .check(let title, let bool):
            Button(action: {
                item.type = .check(title, true)
                item.action?()
            }) {
                HStack(spacing: 2) {
                    Text(title)
                    if item.isPro {
                        Image(systemName: "crown")
                            .font(.subheadline)
                            .foregroundColor(Color.systemOrange)
                    }
                }
            }
            .buttonStyle(CheckButtonStyle(checked: bool, ui: ui))
            .padding(.horizontal)
            .height(SettingsCell.height)
        }
    }

    struct CheckButtonStyle: ButtonStyle {
        let checked: Bool
        let ui: UIManager

        func makeBody(configuration: Self.Configuration) -> some View {
            HStack {
                configuration.label
                Spacer()
                if checked || configuration.isPressed {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.systemGreen)
                        .frame(width: 32, height: 32)
                        .background(UIManager.shared.color.background)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 16), darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(UIManager.shared.color.background)
                        .frame(width: 32, height: 32)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 16), darkShadow: ui.color.darkShadow, lightShadow: ui.color.lightShadow)
                }
            }
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    VStack {
        SettingsCell(item: SettingsItem(type: .popup("Title", "Value"), action: {}))
        SettingsCell(item: SettingsItem(type: .popup("Title", nil), action: {}))
        SettingsCell(item: SettingsItem(type: .toggle("Title", false), action: {}))
        SettingsCell(item: SettingsItem(type: .toggle("Title", true), action: {}))
        SettingsCell(item: SettingsItem(type: .check("Title", false), action: {}))
        SettingsCell(item: SettingsItem(type: .check("Title", true), action: {}))
    }
    .background(UIManager.shared.color.background)
    .environmentObject(UIManager.shared)
}

