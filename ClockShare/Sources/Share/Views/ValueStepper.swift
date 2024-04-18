//
//  ValueStepper.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/24.
//

import Pow
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

    @State private var createAttempts = 0

    public init(
        value: Binding<Double>,
        minimumValue: Double = 0.0,
        maximumValue: Double = 1.0,
        enableManualEditing: Bool = false,
        stepValue: Double = 0.1,
        formatter: NumberFormatter = NumberFormatter(),
        buttonWidth: CGFloat = 32,
        width: CGFloat = 120,
        height: CGFloat = 32,
        borderColor: Color = .black
    ) {
        _value = value
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.enableManualEditing = enableManualEditing
        self.stepValue = stepValue
        self.formatter = formatter
        self.buttonWidth = buttonWidth
        self.width = width
        self.height = height
        self.borderColor = borderColor
    }

    private var number: Binding<String> {
        Binding<String>(
            get: { formatter.string(from: value as NSNumber) ?? "0" },
            set: {
                guard let newValue = formatter.number(from: $0) else { return }
                let value = Double(truncating: newValue)
                if value < minimumValue {
                    self.value = minimumValue
                    // 动画提醒超过界限
                    createAttempts += 1
                } else if value > maximumValue {
                    self.value = maximumValue
                    // 动画提醒超过界限
                    createAttempts += 1
                } else {
                    self.value = value
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
                    // 动画提醒超过界限
                    createAttempts += 1
                } else if newValue > maximumValue {
                    value = maximumValue
                    // 动画提醒超过界限
                    createAttempts += 1
                } else {
                    value = newValue
                }
            }) {
                Image(systemName: "minus")
                    .frame(width: buttonWidth, height: height)
            }
            .foregroundStyle(borderColor)
            .frame(width: buttonWidth, height: height)

            TextField("", text: number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: width - 2 * buttonWidth, height: height)
                .border(borderColor)

            Button(action: {
                let newValue = value + stepValue
                if newValue < minimumValue {
                    value = minimumValue
                    // 动画提醒超过界限
                    createAttempts += 1
                } else if newValue > maximumValue {
                    value = maximumValue
                    // 动画提醒超过界限
                    createAttempts += 1
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
        .changeEffect(.shake(rate: .fast), value: createAttempts)
    }
}

#Preview {
    ValueStepper(value: Binding<Double>.constant(2))
}
