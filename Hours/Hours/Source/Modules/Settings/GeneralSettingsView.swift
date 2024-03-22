//
//  GeneralSettingsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/1/24.
//

import ClockShare
import HoursShare
import PopupView
import RevenueCat
import RevenueCatUI
import SwiftUI
import SwiftUIX

struct GeneralSettingsView: View {
    // MARK: Paywall

    @State var isPaywallPresented: Bool = false

    // MARK: Appearance

    @State var isDarkModePresented: Bool = false
    @State var isLandspaceModePresented: Bool = false
    @State var isAppIconPresented: Bool = false

    // MAKR: Sound
    @State var isSoundTypePresented: Bool = false

    // MARK: Other

    @State var isAboutPresented = false

    @EnvironmentObject var ui: UIManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            scrollView
                .background(ui.colors.background)
        }

        // MARK: Paywall

        .fullScreenCover(isPresented: $isPaywallPresented) {
            PaywallView()
        }

        // MARK: About

        .sheet(isPresented: $isAboutPresented) {
            AboutView(isPresented: $isAboutPresented)
        }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack {
                SettingsPaywallView {
                    if ProManager.default.isLifetime { return }
                    isPaywallPresented = true
                }
                SettingsRecordSection()

                // MARK: Appearance

                SettingsAppearanceSection()

                // MARK: Other

                SettingsSection(title: R.string.localizable.other()) {
                    SettingsNavigateCell(title: R.string.localizable.rate(), action: goToRate)
                    SettingsNavigateCell(title: R.string.localizable.about()) {
                        isAboutPresented = true
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(R.string.localizable.settings())
    }

    func goToRate() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id6479001202?action=write-review")!)
    }
}

#Preview {
    GeneralSettingsView()
}
