//
//  SettingsView.swift
//  DeskClock
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import DeskClockShare
import Neumorphic
import PopupView
import RevenueCat
import SwiftUI
import SwiftUIX

struct SettingsView: View {
    @Binding var isPresented: Bool

    // MARK: Pro

    @State var isPaywallPresented: Bool = false

    // MARK: Appearance

    @State var isDarkModePresented: Bool = false
    @State var isLandspaceModePresented: Bool = false
    @State var isContentsModePresented: Bool = false
    @State var isColorsPresented: Bool = false
    @State var isAppIconPresented: Bool = false

    // MARK: Clock

    @State var isTimeFormatPresented: Bool = false

    // MARK: Pomodoro

    @State var isFocusPresented: Bool = false
    @State var isShortBreakPresented: Bool = false
    @State var isLongBreakPresented: Bool = false

    // MAKR: Sound
    @State var isSoundTypePresented: Bool = false

    // MARK: Other

    @State var isAboutPresented = false

    @EnvironmentObject var ui: UIManager

    var body: some View {
        NavigationView {
            scrollView
        }

        // MARK: Pro

        .sheet(isPresented: $isPaywallPresented) {
            PaywallView(isPresented: $isPaywallPresented)
        }

        // MARK: Appearance

        .popup(isPresented: $isDarkModePresented, view: {
            SettingsDarkModeView(isPresented: $isDarkModePresented)
        }, customize: customize)
        .popup(isPresented: $isLandspaceModePresented, view: {
            SettingsLandspaceModeView(isPresented: $isLandspaceModePresented)
        }, customize: customize)
        .popup(isPresented: $isContentsModePresented, view: {
            SettingsIconStyleView(isPresented: $isContentsModePresented, isPaywallPresented: $isPaywallPresented)
        }, customize: customize)
        .popup(isPresented: $isColorsPresented, view: {
            SettingsColorsView(isPresented: $isColorsPresented, isPaywallPresented: $isPaywallPresented)
        }, customize: customize)
        .sheet(isPresented: $isAppIconPresented) {
            SettingsAppIconView(isPresented: $isAppIconPresented)
        }

        // MARK: Clock

        .popup(isPresented: $isTimeFormatPresented, view: {
            SettingsTimeFormatView(isPresented: $isTimeFormatPresented)
                .environmentObject(ClockManager.shared)
        }, customize: customize)

        // MARK: Pomodoro

        .popup(isPresented: $isFocusPresented, view: {
            SettingsFocusMinutesView(isPresented: $isFocusPresented)
                .environmentObject(PomodoroManager.shared)
        }, customize: customize)
        .popup(isPresented: $isShortBreakPresented, view: {
            SettingsShortBreakMinutesView(isPresented: $isShortBreakPresented)
                .environmentObject(PomodoroManager.shared)
        }, customize: customize)
        .popup(isPresented: $isLongBreakPresented, view: {
            SettingsLongBreakMinutesView(isPresented: $isLongBreakPresented)
                .environmentObject(PomodoroManager.shared)
        }, customize: customize)

        // MARK: Sound

        .popup(isPresented: $isSoundTypePresented, view: {
            SettingsSoundTypeView(isPresented: $isSoundTypePresented)
        }, customize: customize)

        // MARK: About

        .sheet(isPresented: $isAboutPresented) {
            AboutView(isPresented: $isAboutPresented)
        }
    }

    var scrollView: some View {
        GeometryReader { proxy in
            ScrollView {
                SettingsProCell(action: {
                    isPaywallPresented = true
                })

                // MARK: Clock

                SettingsClockSection(
                    isPaywallPresented: $isPaywallPresented,
                    isTimeFormatPresented: $isTimeFormatPresented
                )
                .environmentObject(ClockManager.shared)

                // MARK: Pomodoro

                SettingsPomodoroSection(
                    isPaywallPresented: $isPaywallPresented,
                    isFocusPresented: $isFocusPresented,
                    isShortBreakPresented: $isShortBreakPresented,
                    isLongBreakPresented: $isLongBreakPresented
                )
                .environmentObject(PomodoroManager.shared)

                // MARK: Sound

                SettingsSoundSection(isSoundTypePresented: $isSoundTypePresented)

                // MARK: Appearance

                SettingsAppearanceSection(
                    isPaywallPresented: $isPaywallPresented,
                    isDarkModePresented: $isDarkModePresented,
                    isLandspaceModePresented: $isLandspaceModePresented,
                    isContentsModePresented: $isContentsModePresented,
                    isColorsPresented: $isColorsPresented,
                    isAppIconPresented: $isAppIconPresented
                )

                // MARK: Other

                SettingsSection(title: R.string.localizable.other()) {
                    SettingsNavigateCell(title: R.string.localizable.rate(), action: goToRate)
                    SettingsNavigateCell(title: R.string.localizable.about()) {
                        isAboutPresented = true
                    }
                }

                Color.clear
                    .height(proxy.safeAreaInsets.bottom)
                    .padding(.vertical, .large)
            }
            .font(.headline)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.Neumorphic.main)
        .navigationTitle(R.string.localizable.settings())
        .navigationBarItems(leading: Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.subheadline)
                .foregroundColor(Color.Neumorphic.secondary)
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
}

#Preview {
    SettingsView(isPresented: Binding<Bool>.constant(true))
}
