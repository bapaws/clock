//
//  OnboardingWelcomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        Text(L10n.welcomeTo)
            .font(.largeTitle)
            .height(48)

        ui.background.height(48)

        HStack {
            Image("LaunchImage")
                .resizable()
                .frame(width: 48, height: 48)
            Text(L10n.appName)
                .font(.title)
                .height(36)
        }

        Text(L10n.welcomeText)
            .multilineTextAlignment(.center)
            .foregroundStyle(ui.secondaryLabel)

        Spacer()
    }
}

#Preview {
    OnboardingWelcomeView()
}
