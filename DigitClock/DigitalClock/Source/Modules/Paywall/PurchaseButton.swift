//
//  PurchaseButton.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/4/2.
//

import ClockShare
import DigitalClockShare
import RevenueCat
import SwiftUI
import WidgetKit

struct PurchaseButton: View {
    @State var package: Package? = DigitalProManager.default.lifetimePackage

    @EnvironmentObject var ui: UIManager
    var body: some View {
        Button(action: purchase) {
            HStack(spacing: 32) {
                if let package = DigitalProManager.default.lifetimePackage {
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
        .foregroundStyle(ui.background)
    }

    func purchase() {
        #if DEBUG
        let purchased = PurchasedProduct(
            identifier: "com.bapaws.DigitalClock.lifetime",
            localizedTitle: "Lifetime"
        )
        DigitalProManager.default.purchasedProduct = purchased
        WidgetCenter.shared.reloadAllTimelines()
        #else
        guard let package = DigitalProManager.default.lifetimePackage else { return }

        HUD.show()
        DigitalProManager.default.purchase(package: package) { error in
            HUD.hide()
            WidgetCenter.shared.reloadAllTimelines()
            if let error = error {
                print(error)
                Toast.show(error.localizedDescription)
            } else {
                Toast.show(R.string.localizable.congratulations())
            }
        }
        #endif
    }
}

#Preview {
    PurchaseButton()
}
