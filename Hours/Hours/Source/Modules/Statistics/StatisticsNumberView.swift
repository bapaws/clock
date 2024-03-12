//
//  StatisticsNumberView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/7.
//

import SwiftUI
import SwiftUIX

struct StatisticsNumberView<Number: View>: View {
    var title: String
    var subtitle: String
    var fillColor: Color
    var number: () -> Number

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checkmark")
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(fillColor)
                    }
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.secondaryLabel)
                        .font(.body, weight: .bold)
                    Text(subtitle)
                        .foregroundStyle(Color.tertiaryLabel)
                        .font(.footnote)
                }
                Spacer()
            }

            number()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tertiarySystemBackground)
        }
    }
}

#Preview {
    HStack {
        StatisticsNumberView(title: "Tasks", subtitle: "Total", fillColor: Color.mint) {
            Text("10")
                .font(.title, weight: .bold)
                .foregroundStyle(Color.label)
        }
        StatisticsNumberView(title: "Active Days", subtitle: "Average", fillColor: Color.mint) {
            StatisticsTimeView(time: (1, 2, 3))
        }
    }
}
