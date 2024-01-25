//
//  SettingsStepperCell.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/25.
//

import DigitalClockShare
import SwiftUI

struct SettingsStepperCell: View {
    let title: String

    @Binding var value: Double
    public var minimumValue: Double = 0.0
    public var maximumValue: Double = 1.0
    var stepValue: Double = 1

    var isPro: Bool = false
    public var formatter = NumberFormatter()

    @EnvironmentObject var ui: UIManager

    var body: some View {
        HStack(spacing: 2) {
            Text(title)
            if isPro {
                Image(systemName: "crown")
                    .font(.subheadline)
                    .foregroundColor(ui.colors.secondary)
            }
            Spacer()
            ValueStepper(
                value: $value,
                minimumValue: minimumValue,
                maximumValue: maximumValue,
                stepValue: stepValue,
                formatter: formatter,
                borderColor: ui.colors.primary
            )
        }
        .font(.system(.body, design: .rounded), weight: .ultraLight)
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
    }
}

#Preview {
    SettingsStepperCell(title: "Title", value: Binding.constant(2.0), isPro: true)
}
