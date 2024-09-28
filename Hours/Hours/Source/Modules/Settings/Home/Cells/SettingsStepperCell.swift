//
//  SettingsStepperCell.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/25.
//

import HoursShare
import ClockShare
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
        .font(.body)
        .padding(horizontal: .regular, vertical: .small)
        .height(cellHeight)
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    SettingsStepperCell(title: "Title", value: Binding.constant(2.0), isPro: true)
}
