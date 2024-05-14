//
//  OnboardingWelcomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        Text(R.string.localizable.welcomeTo())
            .font(.largeTitle)
            .height(48)

        ui.background.height(48)

        HStack {
            Image("LaunchImage")
                .resizable()
                .frame(width: 48, height: 48)
            Text(R.string.localizable.appName())
                .font(.title)
                .height(36)
        }

        Text(R.string.localizable.welcomeText())
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Spacer()
    }
}

#Preview {
    OnboardingWelcomeView()
}
