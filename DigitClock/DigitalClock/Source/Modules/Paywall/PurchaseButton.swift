//
//  PurchaseButton.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/4/2.
//

import ClockShare
import DigitalClockShare
import SwiftUI
import RevenueCat

struct PurchaseButton: View {
    @State var package: Package? = ProManager.default.lifetimePackage

    var body: some View {
        Button(action: purchase) {
            HStack(spacing: 32) {
                if let package = ProManager.default.lifetimePackage {
                    Text(package.localizedPriceString)
                        .font(.title2)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(R.string.localizable.adRemoval())
                    Text(R.string.localizable.unlockAll())
                }
                .font(.footnote)
            }
            .padding(.horizontal, .large)
            .padding(.vertical, .small)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8))
        .tint(.label)
        .foregroundStyle(UIManager.shared.colors.background)
    }

    func purchase() {
        guard let package = package else { return }

        HUD.show()
        ProManager.default.purchase(package: package) { error in
            HUD.hide()
            if let error = error {
                print(error)
                Toast.show(error.localizedDescription)
            } else {
                Toast.show(R.string.localizable.congratulations())
            }
        }
    }
}

#Preview {
    PurchaseButton()
}
