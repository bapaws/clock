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

struct PaywallView: View {
    @State var packages: [Package] = ProManager.default.availablePackages

    @State var selectedPackage: Package? = ProManager.default.availablePackages.first

    @State var urlString: String?

    @Environment(\.dismiss) var dismiss

    private let infos = [
        R.string.localizable.proInfo1(),
        R.string.localizable.proInfo2(),
        R.string.localizable.proInfo3(),
        R.string.localizable.proInfo4(),
    ]

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Group {
            if packages.count == 0 {
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
            } else {
                scrollView
            }
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
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(R.string.localizable.premium())
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

                    Text(R.string.localizable.subscriptionWarning())
                        .font(.caption2)
                        .padding(.vertical, .large)
                        .padding(.horizontal)

                    Spacer()

                    HStack {
                        Spacer()
                        Button {
                            urlString = "https://privacy.bapaws.com/Hours/terms.html"
                        } label: {
                            Text(R.string.localizable.terms())
                                .font(.caption)
                                .foregroundColor(.tertiaryLabel)
                        }
                        Text(R.string.localizable.and())
                            .font(.caption)
                            .foregroundColor(.tertiaryLabel)
                        Button {
                            urlString = "https://privacy.bapaws.com/Hours/privacy.html"
                        } label: {
                            Text(R.string.localizable.privacy())
                                .font(.caption)
                                .foregroundColor(.tertiaryLabel)
                        }
                        Spacer()
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                ZStack(alignment: .topTrailing) {
                    if let image = R.image.hourglass() {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width, height: proxy.size.width / 3 * 2)
                    }

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white)
                            .font(.title)
                            .frame(width: 42, height: 42)
                    }
                    .padding(.trailing, proxy.safeAreaInsets.trailing)
                    .padding(.trailing, .small)
                    .padding(.top, proxy.safeAreaInsets.top)
                }
            }
            .safeAreaInset(edge: .bottom) {
                footer
            }
            .ignoresSafeArea()

            .sheet(item: $urlString) { urlString in
                SafariView(url: URL(string: urlString)!)
            }
        }
    }

    var footer: some View {
        VStack {
            Button(action: purchase) {
                VStack {
                    Text(R.string.localizable.getPro())
                        .font(.headline)
                        .frame(width: .greedy)
                        .foregroundStyle(.white)
                    Text(R.string.localizable.sale())
                        .font(.footnote)
                        .foregroundColor(ui.background)
                }
            }
            .frame(width: .greedy, height: 54)
            .padding(.horizontal)
            .background(ui.primary)
            .cornerRadius(16)

            Button(action: restore) {
                Text(R.string.localizable.restore())
                    .foregroundColor(.tertiaryLabel)
                    .frame(width: .greedy, height: 32)
                    .font(.caption)
            }
        }
        .padding()
        .padding(.bottom)
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
                dismiss()
                Toast.show(R.string.localizable.congratulations())
            }
        }
    }
}

#Preview {
    PaywallView()
}
