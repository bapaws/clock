//
//  StatisticsNumberView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/7.
//

import HoursShare
import SwiftUI
import SwiftUIX

struct StatisticsNumberView<Number: View>: View {
    var imageName: String
    var title: String
    var subtitle: String
    var fillColor: Color
    var number: () -> Number

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: imageName)
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
                .frame(height: 36)
        }
        .padding()
        .background(ui.secondaryBackground)
        .cornerRadius(16)
    }
}

#Preview {
    HStack {
        StatisticsNumberView(imageName: "checkmark", title: "Tasks", subtitle: "Total", fillColor: UIManager.shared.primary) {
            Text("10")
                .font(.title, weight: .bold)
                .foregroundStyle(Color.label)
        }
        StatisticsNumberView(imageName: "hourglass", title: "Active Days", subtitle: "Average", fillColor: UIManager.shared.primary) {
            StatisticsTimeView(time: (2, 1, 2, 3))
        }
    }
}
