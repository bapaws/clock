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
    var mainColor: Color
    var textColor: Color
    var darkShadowColor: Color
    var lightShadowColor: Color
    var padding: EdgeInsets

    public init(mainColor: Color, textColor: Color, darkShadowColor: Color, lightShadowColor: Color, padding: EdgeInsets = EdgeInsets()) {
        self.mainColor = mainColor
        self.textColor = textColor
        self.darkShadowColor = darkShadowColor
        self.lightShadowColor = lightShadowColor
        self.padding = padding
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        SoftDynamicButton(configuration: configuration, mainColor: mainColor, textColor: textColor, darkShadowColor: darkShadowColor, lightShadowColor: lightShadowColor, padding: padding)
    }

    struct SoftDynamicButton: View {
        let configuration: ButtonStyle.Configuration

        var mainColor: Color
        var textColor: Color
        var darkShadowColor: Color
        var lightShadowColor: Color
        var padding: EdgeInsets

        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            HStack {
                configuration.label

                if configuration.isPressed {
                    Circle()
                        .fill(mainColor)
                        .scaleEffect(configuration.isPressed ? 0.97 : 1)
                        .softInnerShadow(Circle())
                        .overlay {
                            Image(systemName: "chevron.forward")
                                .font(.footnote)
                        }
                        .frame(width: 36, height: 36)
                } else {
                    Circle()
                        .fill(mainColor)
                        .scaleEffect(configuration.isPressed ? 0.97 : 1)
                        .softOuterShadow()
                        .overlay {
                            Image(systemName: "chevron.forward")
                                .font(.footnote)
                        }
                        .frame(width: 36, height: 36)
                }
            }
            .contentShape(Rectangle())
            .foregroundColor(isEnabled ? textColor : darkShadowColor)
            .padding(padding)
        }
    }
}

public extension Button {
    func softNavigateCellButtonStyle(padding: EdgeInsets = EdgeInsets(), mainColor: Color = Color.Neumorphic.main, textColor: Color = Color.Neumorphic.secondary, darkShadowColor: Color = Color.Neumorphic.darkShadow, lightShadowColor: Color = Color.Neumorphic.lightShadow) -> some View {
        buttonStyle(SettingsNavigateCellButtonStyle(mainColor: mainColor, textColor: textColor, darkShadowColor: darkShadowColor, lightShadowColor: lightShadowColor, padding: padding))
    }
}

// MARK: Toggle

private struct SoftSettingsSwitchToggleStyle: ToggleStyle {
    var tintColor: Color
    var offTintColor: Color

    var mainColor: Color
    var darkShadowColor: Color
    var lightShadowColor: Color

    var hideLabel: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            if !hideLabel {
                configuration.label
                    .font(.body)
                Spacer()
            }
            ZStack {
                Capsule()
                    .fill(mainColor)
                    .softOuterShadow()
                    .frame(width: 55, height: 35)

                Capsule()
                    .fill(configuration.isOn ? tintColor : offTintColor)
                    .softInnerShadow(Capsule(), darkShadow: configuration.isOn ? tintColor : darkShadowColor, lightShadow: configuration.isOn ? tintColor : lightShadowColor, spread: 0.35, radius: 3)
                    .frame(width: 50, height: 30)

                Circle()
                    .fill(mainColor)
                    .softOuterShadow(darkShadow: darkShadowColor, lightShadow: lightShadowColor, offset: configuration.isOn ? 0 : 2, radius: 1)
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
    func softSettingsSwitchToggleStyle(tint: Color = .green, offTint: Color = Color.Neumorphic.main, mainColor: Color = Color.Neumorphic.main, darkShadowColor: Color = Color.Neumorphic.darkShadow, lightShadowColor: Color = Color.Neumorphic.lightShadow, labelsHidden: Bool = false) -> some View {
        return toggleStyle(SoftSettingsSwitchToggleStyle(tintColor: tint, offTintColor: offTint, mainColor: mainColor, darkShadowColor: darkShadowColor, lightShadowColor: lightShadowColor, hideLabel: labelsHidden))
    }
}
