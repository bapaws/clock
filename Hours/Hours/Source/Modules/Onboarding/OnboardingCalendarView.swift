//
//  OnboardingCalendarView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import SwiftUI

struct OnboardingCalendarView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .shadow(color: .systemGray4, x: 0, y: 0, blur: 10)

            VStack(spacing: 0) {
                let now = Date()
                Text(now.toString(.custom("MMM")))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: .greedy, height: 24, alignment: .center)
                    .background(
                        LinearGradient(colors: [
                            Color(hexadecimal6: 0xFF6159),
                            Color(hexadecimal6: 0xEA4B43)
                        ], startPoint: .top, endPoint: .bottom)
                    )
                Text(now.toString(.custom("d")))
                    .foregroundStyle(.black)
                    .font(.system(size: 42, weight: .light, design: .rounded))
                    .frame(.greedy)
                    .background(
                        LinearGradient(colors: [
                            Color(hexadecimal6: 0xFBF9F8),
                            Color(hexadecimal6: 0xF3F2EE)
                        ], startPoint: .top, endPoint: .bottom)
                    )
            }
            .cornerRadius(15)
        }
        .frame(width: 72, height: 72)

        ui.background.height(48)

        Text(R.string.localizable.calendarTitle())
            .font(.title)
            .height(36)

        Text(R.string.localizable.calendarDesc())
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Spacer()
    }
}

#Preview {
    OnboardingCalendarView()
}
