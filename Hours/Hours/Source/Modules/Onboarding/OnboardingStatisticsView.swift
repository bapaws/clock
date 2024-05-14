//
//  OnboardingStatisticsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/14.
//

import SwiftUI

struct OnboardingStatisticsView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(color: .systemGray4, x: 0, y: 0, blur: 10)

            LinearGradient(colors: [
                Color(hexadecimal6: 0xF4CD99),
                Color(hexadecimal6: 0xFF9600)
            ], startPoint: .top, endPoint: .bottom)
                .cornerRadius(15)

            Image(systemName: "chart.bar.xaxis.ascending")
                .font(.system(size: 48))
                .foregroundStyle(.white)
        }
        .frame(width: 72, height: 72)

        ui.background.height(48)

        Text(R.string.localizable.statisticsTitle())
            .font(.title)
            .height(36)

        Text(R.string.localizable.statisticsDesc())
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Spacer()
    }
}

#Preview {
    OnboardingStatisticsView()
}
