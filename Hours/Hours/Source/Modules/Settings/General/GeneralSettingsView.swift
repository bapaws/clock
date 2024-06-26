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
import SwiftUI
import SwiftUIX

struct GeneralSettingsView: View {
    // MARK: Paywall

    @Binding var isPaywallPresented: Bool

    // MARK: Appearance

    @State var isDarkModePresented: Bool = false
    @State var isLandspaceModePresented: Bool = false
    @State var isAppIconPresented: Bool = false

    // MAKR: Sound
    @State var isSoundTypePresented: Bool = false

    // MARK: Other

    @State var isOnboardingPresented = false
    @State var isAboutPresented = false
    @State var isFeedbackPresented = false

    @EnvironmentObject var ui: UIManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        scrollView
            .navigationTitle(R.string.localizable.settings())
            .background(ui.background)

            // MARK: Other

            .sheet(isPresented: $isOnboardingPresented) {
                let indices = app.isHealthAvailable ? OnboardingIndices.allCases : [.welcome, .appScreenTime, .calendar, .health]
                OnboardingView(onboardingIndices: indices) {
                    isOnboardingPresented.toggle()
                }
            }
            .sheet(isPresented: $isAboutPresented) {
                AboutView(isPresented: $isAboutPresented)
            }
            .sheet(isPresented: $isFeedbackPresented) {
                FeedbackView()
            }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack {
                SettingsPaywallView {
                    if ProManager.default.isLifetime { return }
                    isPaywallPresented = true
                }
                SettingsRecordSection(isPaywallPresented: $isPaywallPresented)

                // MARK: Sound

                SettingsSoundSection()

                // MARK: Appearance

                SettingsAppearanceSection()

                // MARK: Other

                SettingsSection(title: R.string.localizable.other()) {
                    SettingsNavigateCell(title: R.string.localizable.onboarding()) {
                        isOnboardingPresented.toggle()
                    }
                    SettingsNavigateCell(title: R.string.localizable.rate(), action: goToRate)
                    SettingsNavigateCell(title: R.string.localizable.feedback()) {
                        isFeedbackPresented = true
                    }
                    SettingsNavigateCell(title: R.string.localizable.about()) {
                        isAboutPresented = true
                    }
                }
            }
            .padding()
            .padding(.bottom)
        }
    }

    func goToRate() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id6479001202?action=write-review")!)
    }
}

#Preview {
    GeneralSettingsView(isPaywallPresented: .constant(false))
}
