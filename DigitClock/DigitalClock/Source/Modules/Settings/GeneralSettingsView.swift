//
//  GeneralSettingsView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/24.
//

import ClockShare
import DigitalClockShare
import PopupView
import RevenueCat
import SwiftUI
import SwiftUIX

struct GeneralSettingsView: View {
    @Binding var isPresented: Bool

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
        NavigationView {
            scrollView
        }
        .foregroundStyle(ui.colors.primary)
        .background(ui.colors.background)
        .font(.system(.body, design: .rounded), weight: .ultraLight)

        // MARK: Appearance

        .popup(isPresented: $isDarkModePresented, view: {
            SettingsDarkModeView(isPresented: $isDarkModePresented)
        }, customize: customize)
        .popup(isPresented: $isLandspaceModePresented, view: {
            SettingsLandspaceModeView(isPresented: $isLandspaceModePresented)
        }, customize: customize)
        .sheet(isPresented: $isAppIconPresented) {
            SettingsAppIconView(isPresented: $isAppIconPresented)
        }

        // MARK: Sound

        .popup(isPresented: $isSoundTypePresented, view: {
            SettingsSoundTypeView(isPresented: $isSoundTypePresented)
        }, customize: customize)

        // MARK: About

        .sheet(isPresented: $isAboutPresented) {
            DigitalAboutView(isPresented: $isAboutPresented)
        }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack {
                PaywallView()

                SettingsSoundSection(isSoundTypePresented: $isSoundTypePresented)

                // MARK: Appearance

                SettingsAppearanceSection(
                    isDarkModePresented: $isDarkModePresented,
                    isLandspaceModePresented: $isLandspaceModePresented
                )

                // MARK: App Icons

                SettingsAppIconSection(isAppIconPresented: $isAppIconPresented)

                // MARK: Other

                SettingsSection(title: R.string.localizable.other()) {
                    SettingsNavigateCell(title: R.string.localizable.rate(), action: goToRate)
                    SettingsNavigateCell(title: R.string.localizable.about()) {
                        isAboutPresented = true
                    }
                }
                Color.clear
                    .height(54)
                    .padding(.vertical, .large)
            }
        }
        .navigationTitle(R.string.localizable.settings())
        .navigationBarItems(leading: Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.subheadline)
        }))
    }

    func customize<PopupContent: View>(parameters: Popup<PopupContent>.PopupParameters) -> Popup<PopupContent>.PopupParameters {
        parameters
            .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: true))
            .position(.bottom)
            .appearFrom(.bottom)
            .closeOnTapOutside(true)
            .backgroundColor(Color.black.opacity(0.35))
            .animation(.spring(duration: 0.3))
    }

    func goToRate() {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/id6474898768?action=write-review")!)
    }

    func purchase() {
        guard let package = DigitalProManager.default.lifetimePackage else { return }

        HUD.show()
        DigitalProManager.default.purchase(package: package) { error in
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
        DigitalProManager.default.restorePurchases { error in
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
    GeneralSettingsView(isPresented: Binding<Bool>.constant(true))
}
