//
//  PaywallView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/29.
//

import ClockShare
import HoursShare
import RevenueCat
import SwiftUI
import SwiftUIX

@MainActor struct PaywallView: View {
    @State var packages: [Package] = ProManager.default.availablePackages

    @State var selectedPackage: Package? = ProManager.default.availablePackages.first

    @State var urlString: String?

    @Environment(\.dismiss) var dismiss

    private let infos = [
        L10n.proInfo1,
        L10n.proInfo2,
        L10n.proInfo3,
        L10n.proInfo4,
    ]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if packages.count == 0 {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(.greedy, alignment: .center)
            } else {
                scrollView
            }

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white)
                    .font(.title)
                    .frame(width: 54, height: 54)
            }
            .padding(.trailing, .small)
        }
        .frame(.greedy)
        .background(ui.background)
        .onAppear {
            guard selectedPackage == nil else { return }

            HUD.show()
            ProManager.default.getOfferings { error in
                HUD.hide()

                guard error == nil else { return }
                selectedPackage = ProManager.default.availablePackages.first
                packages = ProManager.default.availablePackages
            }
        }
    }

    @ViewBuilder var scrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Image(asset: Asset.hourglass)
                    .resizable()
                    .scaledToFit()

                Text(L10n.premium)
                    .font(.title)
                    .padding(.top, .large)
                    .padding(.bottom)
                    .padding(.horizontal)

                ForEach(infos, id: \.self) { info in
                    PaywallFeatureItemView(info: info)
                }
                .padding(.bottom, .small)
                .padding(.horizontal)

                ForEach(packages, id: \.self) { package in
                    PaywallPackageItemView(selectedPackage: $selectedPackage, package: package)
                }
                .padding(.horizontal)

                Text(L10n.subscriptionWarning)
                    .font(.footnote)
                    .foregroundColor(.tertiaryLabel)
                    .padding(.vertical, .large)
                    .padding(.horizontal)

                Spacer()

                HStack(spacing: 16) {
                    Spacer()
                    Button {
                        urlString = "https://bapaws.super.site/隐私政策/用户协议"
                    } label: {
                        Text(L10n.terms)
                    }
                    Text("|")
                    Button {
                        urlString = "https://bapaws.super.site/隐私政策/隐私协议"
                    } label: {
                        Text(L10n.privacy)
                    }
                    Text("|")
                    Button(action: restore) {
                        Text(L10n.restore)
                    }
                    Spacer()
                }
                .font(.footnote)
                .foregroundColor(.tertiaryLabel)
            }
        }
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .ignoresSafeArea(.container, edges: .top)

        .sheet(item: $urlString) { urlString in
            SafariView(url: URL(string: urlString)!)
        }
    }

    var footer: some View {
        VStack {
            Button(action: purchase) {
                VStack {
                    Text(L10n.getPro)
                        .font(.headline)
                        .frame(width: .greedy)
                        .foregroundStyle(.white)
                    Text(L10n.sale)
                        .font(.footnote)
                        .foregroundColor(ui.background)
                }
            }
            .frame(width: .greedy, height: 60)
            .padding(.horizontal)
            .background(ui.primary)
            .cornerRadius(16)
        }
        .padding()
        .background(ui.background)
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
                dismiss()
                Toast.show(L10n.congratulations)
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
                dismiss()
                Toast.show(L10n.congratulations)
            }
        }
    }
}

#Preview {
    PaywallView()
}
