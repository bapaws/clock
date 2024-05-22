//
//  SettingsPaywallView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/18.
//

import ClockShare
import SwiftUI

struct SettingsPaywallView: View {
    var action: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(R.string.localizable.appName())
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.orange)
                }
                .font(.title3)

                Text(ProManager.default.isPro ? R.string.localizable.slogan() : R.string.localizable.unlockPro())
            }
            .foregroundStyle(.white)

            Spacer()

            Button(action: action) {
                Text(ProManager.default.purchasedProduct?.localizedTitle ?? R.string.localizable.tryFree())
                    .font(.headline)
                    .padding()
                    .foregroundStyle(ui.colors.primary)
                    .background {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.white)
                    }
            }
        }
        .padding()
        .padding(.horizontal, .small)
        .padding(.vertical)
        .background(ui.colors.primary)
        .cornerRadius(32)
        .padding(.vertical)
        .onTapGesture(perform: action)
    }
}

#Preview {
    SettingsPaywallView {}
}
