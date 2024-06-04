//
//  StatisticsDatePicker.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Perception
import SwiftUI

struct StatisticsDatePicker<Center: View>: View {
    let previous: (() -> Void)?
    let next: (() -> Void)?
    let center: () -> Center

    var body: some View {
        WithPerceptionTracking {
            HStack {
                Button(action: {
                    previous?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.vertical, .small)
                        .foregroundStyle(previous == nil ? .placeholderText : ui.label)
                        .frame(width: 80)
                }
                .disabled(previous == nil)

                center()
                    .frame(.greedy)

                Button(action: {
                    next?()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.vertical, .small)
                        .foregroundStyle(next == nil ? .placeholderText : ui.label)
                        .frame(width: 80)
                }
                .disabled(next == nil)
            }
            .foregroundStyle(ui.label)
            .height(48)
        }
    }
}

#Preview {
    StatisticsDatePicker(previous: {}, next: nil) {
        VStack {
            Text(R.string.localizable.today())
                .font(.headline)
            Text(Date().toString(.date(.medium)))
                .font(.subheadline)
        }
        .frame(.greedy)
    }
}
