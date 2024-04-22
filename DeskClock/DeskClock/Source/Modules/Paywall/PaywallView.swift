//
//  PaywallView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/29.
//

import ClockShare
import DeskClockShare
import Neumorphic
import RevenueCat
import SwiftUI
import SwiftUIX

struct PaywallView: View {
    @Binding var isPresented: Bool

    @State var packages: [Package] = ProManager.default.availablePackages

    @State var selectedPackage: Package? = ProManager.default.availablePackages.first

    private let infos = [
        R.string.localizable.proInfo1(),
        R.string.localizable.proInfo2(),
        R.string.localizable.proInfo3(),
        R.string.localizable.proInfo4(),
        R.string.localizable.proInfo5(),
    ]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    if packages.count == 0 {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    } else {
                        scrollView
                            .frame(.greedy)
                    }
                    Button(action: purchase) {
                        VStack {
                            Text(R.string.localizable.getPro())
                                .font(.headline)
                                .frame(width: .greedy)
                            Text(R.string.localizable.sale())
                                .font(.footnote)
                                .foregroundColor(UIManager.shared.colors.secondary)
                        }
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: 16), padding: 8)
                    .frame(width: .greedy, height: 54)
                    .padding(.horizontal, .large)
                    .padding(.top, .small)

                    Button(action: restore) {
                        Text(R.string.localizable.restore())
                            .foregroundColor(.tertiaryLabel)
                            .frame(width: .greedy, height: 32)
                            .font(.caption)
                    }
                    .padding(.horizontal, .large)
                    Color.clear
                        .height(proxy.safeAreaInsets.bottom + 8)
                }
                .background(Color.Neumorphic.main)
                .edgesIgnoringSafeArea(.bottom)
                .frame(.greedy)
            }
            .background(Color.Neumorphic.main)
            .navigationTitle(R.string.localizable.proMembership())
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .font(.subheadline)
                    .foregroundColor(Color.Neumorphic.secondary)
            }))
        }
        .onAppear {
            ClockManager.shared.resumeTimer()

            guard selectedPackage == nil else { return }
            HUD.show()
            ProManager.default.getOfferings { error in
                HUD.hide()

                guard error == nil else { return }
                selectedPackage = ProManager.default.availablePackages.first
                packages = ProManager.default.availablePackages
            }
        }
        .onDisappear {
            ClockManager.shared.suspendTimer()
        }
    }

    @ViewBuilder var scrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                ClockLandspaceView(color: Colors.classic(mode: UIManager.shared.darkMode), colonWidth: 16)
                    .environmentObject(ClockManager.shared)
                    .frame(width: 280, height: 130)
                    .padding(.vertical, .large)
                    .padding(.horizontal, .extraSmall)

                ForEach(infos, id: \.self) { info in
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(UIManager.shared.colors.secondary)
                            .font(.callout)
                        Text(info)
                            .font(.subheadline)
                        Spacer()
                    }
                }
                .padding(.bottom, .small)
                .padding(.horizontal)

                ForEach(packages, id: \.self) { package in
                    Button(action: {
                        selectedPackage = package
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    if selectedPackage == package {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(UIManager.shared.colors.secondary)
                                            .font(.headline)
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
                                        .background(UIManager.shared.colors.secondary)
                                        .foregroundColor(Color.white)
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, .regular)

                Text(R.string.localizable.subscriptionWarning())
                    .font(.caption2)
                    .padding(.vertical, .large)
            }
            .padding(.horizontal, .large)
        }
        .foregroundColor(Color.Neumorphic.secondary)
        .font(.body)
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

    func purchase() {
        guard let package = selectedPackage else { return }

        HUD.show()
        ProManager.default.purchase(package: package) { error in
            HUD.hide()
            if let error = error {
                print(error)
                Toast.show(error.localizedDescription)
            } else {
                isPresented = false
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
            } else {
                isPresented = false
                Toast.show(R.string.localizable.congratulations())
            }
        }
    }
}

#Preview {
    PaywallView(isPresented: Binding<Bool>.constant(true))
}
