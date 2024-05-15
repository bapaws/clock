//
//  OnboardingHealthView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/14.
//

import SwiftUI

struct OnboardingHealthView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .systemGray4, x: 0, y: 0, blur: 10)

            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 32, height: 28)
                .padding(.trailing, 8)
                .padding(.top, 12)
                .foregroundStyle(
                    LinearGradient(colors: [
                        Color(hexadecimal6: 0xFF61AA),
                        Color(hexadecimal6: 0xFF2518)
                    ], startPoint: .top, endPoint: .bottom)
                )
        }
        .frame(width: 72, height: 72)

        ui.background.height(48)

        Text(R.string.localizable.healthTitle())
            .font(.title)
            .height(36)

        Text(R.string.localizable.healthDesc())
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Spacer()
    }
}

#Preview {
    OnboardingHealthView()
}
