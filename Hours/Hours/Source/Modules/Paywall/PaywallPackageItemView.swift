//
//  PaywallPackageItemView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/20.
//

import HoursShare
import RevenueCat
import SwiftUI
import SwiftUIX

struct PaywallPackageItemView: View {
    @Binding var selectedPackage: Package?
    let package: Package
    var body: some View {
        Button(action: {
            selectedPackage = package
        }) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        if selectedPackage == package {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(ui.secondary)
                                .font(.headline, weight: .regular)
                        } else {
                            Image(systemName: "circle")
                                .font(.headline)
                        }
                        Text(package.storeProduct.localizedTitle)
                            .font(.headline)
                    }
                    .padding(.bottom, .extraSmall)
                    Text(package.storeProduct.localizedDescription)
                        .font(.footnote)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    Text(package.localizedPriceString)
                        .font(.title2)
                    if let days = freeTrialDays(package: package) {
                        Text(R.string.localizable.freeTrialDays("\(days)"))
                            .background(ui.secondary)
                            .foregroundColor(Color.white)
                            .font(.footnote)
                    }
                }
            }
            .padding()
        }
        .background(ui.secondaryBackground)
        .overlay {
            if selectedPackage == package {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ui.primary, lineWidth: 2)
            }
        }
        .cornerRadius(16)
        .padding(.top)
    }

    func freeTrialDays(package: Package) -> Int? {
        guard let introductoryPrice = package.storeProduct.introductoryDiscount, introductoryPrice.paymentMode == .freeTrial else { return nil }
        let subscriptionPeriod = introductoryPrice.subscriptionPeriod
        switch subscriptionPeriod.unit {
        case .day:
            return subscriptionPeriod.value
        case .week:
            return subscriptionPeriod.value * 7
        default:
            return nil
        }
    }
}

// #Preview {
//    PaywallPackageItemView()
// }
