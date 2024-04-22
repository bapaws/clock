//
//  PaywallView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/29.
//

import ClockShare
import DigitalClockShare
import RevenueCat
import SwiftUI
import SwiftUIX

struct PaywallView: View {
    @State var package: Package? = ProManager.default.lifetimePackage

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var ui: UIManager

    var body: some View {
        ClockLandspaceView(color: Colors.classic(mode: ui.darkMode))
            .environmentObject(ClockManager.shared)
            .height(130)
            .border(cornerRadius: 16, style: StrokeStyle())
            .padding(.horizontal, .large)
            .padding(.top, .large)
            .onAppear {
                ClockManager.shared.resumeTimer()

                guard package == nil else { return }
                HUD.show()
                ProManager.default.getOfferings { error in
                    HUD.hide()

                    guard error == nil else { return }
                    package = ProManager.default.lifetimePackage
                }
            }
            .onDisappear {
                ClockManager.shared.suspendTimer()
            }

        if !ProManager.default.isPro {
            PurchaseButton()
                .padding(.top)

            Button(action: restore) {
                Text(R.string.localizable.restore())
                    .foregroundColor(.secondary)
                    .frame(width: .greedy, height: 28)
                    .font(.caption)
            }
            .padding(.horizontal, .large)
        }
    }

    func restore() {
        HUD.show()
        ProManager.default.restorePurchases { error in
            HUD.hide()
            if let error = error {
                print(error)
                Toast.show(error.localizedDescription)
                Toast.show(R.string.localizable.congratulations())
            }
        }
    }
}

#Preview {
    PaywallView()
}
