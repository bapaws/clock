//
//  StatisticsNumberView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/7.
//

import HoursShare
import Perception
import SwiftUI
import SwiftUIX

struct StatisticsNumberView<Number: View>: View {
    var imageName: String
    var title: String
    var subtitle: String
    var iconForegroundColor: Color = .white
    var iconBackgound: Color
    var number: () -> Number

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: imageName)
                        .frame(width: 36, height: 36)
                        .foregroundStyle(iconForegroundColor)
                        .background(iconBackgound)
                        .cornerRadius(8)
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
}

#Preview {
    HStack {
        StatisticsNumberView(imageName: "checkmark", title: "Tasks", subtitle: "Total", iconBackgound: UIManager.shared.primary) {
            Text("10")
                .font(.title, weight: .bold)
                .foregroundStyle(Color.label)
        }
        StatisticsNumberView(imageName: "hourglass", title: "Active Days", subtitle: "Average", iconBackgound: UIManager.shared.primary) {
            StatisticsTimeView(time: TimeLength(integer: 1231231231))
        }
    }
}
