//
//  NeumorphicStyle.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/27.
//

import Foundation
import Neumorphic
import SwiftUI

// MARK: Setting Navigate Cell

private struct SettingsNavigateCellButtonStyle: ButtonStyle {
    var padding: EdgeInsets
    var color: ColorStyle

    public init(padding: EdgeInsets = EdgeInsets(), color: ColorStyle) {
        self.padding = padding
        self.color = color
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        SoftDynamicButton(configuration: configuration, padding: padding, color: color)
    }

    struct SoftDynamicButton: View {
        let configuration: ButtonStyle.Configuration

        var padding: EdgeInsets
        var color: ColorStyle

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            HStack {
                configuration.label

                if configuration.isPressed {
                    Circle()
                        .fill(color.background)
                        .scaleEffect(configuration.isPressed ? 0.97 : 1)
                        .softInnerShadow(Circle(), darkShadow: color.darkShadow, lightShadow: color.lightShadow)
                        .overlay {
                            Image(systemName: "chevron.forward")
                                .font(.footnote)
                        }
                        .frame(width: 36, height: 36)
                } else {
                    Circle()
                        .fill(color.background)
                        .scaleEffect(configuration.isPressed ? 0.97 : 1)
                        .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow)
                        .overlay {
                            Image(systemName: "chevron.forward")
                                .font(.footnote)
                        }
                        .frame(width: 36, height: 36)
                }
            }
            .contentShape(Rectangle())
            .foregroundColor(isEnabled ? color.secondaryLabel : color.darkShadow)
            .padding(padding)
        }
    }
}

public extension Button {
    func softNavigateCellButtonStyle(padding: EdgeInsets = EdgeInsets(), color: ColorStyle) -> some View {
        buttonStyle(SettingsNavigateCellButtonStyle(padding: padding, color: color))
    }
}

// MARK: Toggle

private struct SoftSettingsSwitchToggleStyle: ToggleStyle {
    var hideLabel: Bool

    var color: ColorStyle

    public func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            if !hideLabel {
                configuration.label
                    .font(.body)
                Spacer()
            }
            ZStack {
                Capsule()
                    .fill(color.background)
                    .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow)
                    .frame(width: 55, height: 35)

                Capsule()
                    .fill(configuration.isOn ? color.primary : color.background)
                    .softInnerShadow(Capsule(), darkShadow: configuration.isOn ? color.primary : color.darkShadow, lightShadow: configuration.isOn ? color.primary : color.lightShadow, spread: 0.35, radius: 3)
                    .frame(width: 50, height: 30)

                Circle()
                    .fill(color.background)
                    .softOuterShadow(darkShadow: color.darkShadow, lightShadow: color.lightShadow, offset: configuration.isOn ? 0 : 2, radius: 1)
                    .frame(width: 22, height: 22)
                    .offset(x: configuration.isOn ? 11 : -11)
                    .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

public extension Toggle {
    func softSettingsSwitchToggleStyle(labelsHidden: Bool = false, color: ColorStyle) -> some View {
        return toggleStyle(SoftSettingsSwitchToggleStyle(hideLabel: labelsHidden, color: color))
    }
}
