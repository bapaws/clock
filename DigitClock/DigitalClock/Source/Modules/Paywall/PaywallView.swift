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

    var body: some View {
        ClockLandspaceView(color: Colors.classic(scheme: colorScheme))
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
            Button(action: purchase) {
                HStack {
                    if let package = ProManager.default.lifetimePackage {
                        Text(package.localizedPriceString)
                            .font(.title2)
                    }
                    Text(R.string.localizable.adRemoval())
                        .font(.subheadline)
                }
                .padding(.horizontal, .large)
                .padding(.vertical, .small)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8))
            .tint(.label)
            .foregroundStyle(UIManager.shared.colors.background)
            .frame(width: .greedy, height: 54)
            .padding(.horizontal, .large)
            .padding(.top, .small)

            Button(action: restore) {
                Text(R.string.localizable.restore())
                    .foregroundColor(.secondary)
                    .frame(width: .greedy, height: 28)
                    .font(.caption)
            }
            .padding(.horizontal, .large)
        }
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
