//
//  ValueStepper.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/24.
//

import SwiftUI
import SwiftUIX

public protocol ValueStepperType {
    static func += (lhs: inout ValueStepperType, rhs: ValueStepperType)
    static func -= (lhs: inout ValueStepperType, rhs: ValueStepperType)
}

public struct ValueStepper: View {
    @Binding var value: Double

    public var minimumValue: Double = 0.0
    public var maximumValue: Double = 1.0
    public var enableManualEditing: Bool = false
    public var stepValue: Double = 0.1
    public var formatter = NumberFormatter()

    public var buttonWidth: CGFloat = 32
    public var width: CGFloat = 120
    public var height: CGFloat = 32
    public var borderColor: Color = .black

    private var number: Binding<String> {
        Binding<String>(
            get: { formatter.string(from: value as NSNumber) ?? "0" },
            set: {
                if let newValue = formatter.number(from: $0) {
                    value = Double(truncating: newValue)
                }
            }
        )
    }

    public var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                let newValue = value - stepValue
                if newValue < minimumValue {
                    value = minimumValue
                } else if newValue > maximumValue {
                    value = maximumValue
                } else {
                    value = newValue
                }
            }) {
                Image(systemName: "minus")
                    .frame(width: buttonWidth, height: height)
            }
            .foregroundStyle(borderColor)
            .frame(width: buttonWidth, height: height)

            TextField("Number", text: number)
                .multilineTextAlignment(.center)
                .frame(width: width - 2 * buttonWidth, height: height)
                .border(borderColor)

            Button(action: {
                let newValue = value + stepValue
                if newValue < minimumValue {
                    value = minimumValue
                } else if newValue > maximumValue {
                    value = maximumValue
                } else {
                    value = newValue
                }
            }) {
                Image(systemName: "plus")
                    .frame(width: buttonWidth, height: height)
            }
            .foregroundStyle(borderColor)
            .frame(width: buttonWidth, height: height)
        }
        .height(height)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.clear)
                .border(cornerRadius: 8, style: StrokeStyle())
                .foregroundStyle(borderColor)
        }
    }
}

#Preview {
    ValueStepper(value: Binding<Double>.constant(2))
}
