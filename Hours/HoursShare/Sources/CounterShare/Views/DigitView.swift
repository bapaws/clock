//
//  DigitView.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/20.
//

import ClockShare
import SwiftUI

public struct DigitView: View {
    public let tens: Int
    public let ones: Int

    public var spacing: CGFloat = 0

    public init(tens: Int, ones: Int, spacing: CGFloat = 0) {
        self.tens = tens
        self.ones = ones
        self.spacing = spacing
    }

    public var body: some View {
        Text("\(tens)\(ones)")
            .monospacedDigit()
    }
}

#Preview {
    DigitView(tens: 2, ones: 5)
}
