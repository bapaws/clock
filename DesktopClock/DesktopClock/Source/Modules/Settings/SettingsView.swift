//
//  SettingsView.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import Neumorphic
import PopupView
import RevenueCat
import RevenueCatUI
import SwiftUI
import SwiftUIIntrospect
import SwiftUIX

struct SettingsView: View {
    @Binding var isPresented: Bool

    // MARK: Pro

    @State var isPaywallPresented: Bool = false

    // MARK: Appearance

    @State var isDarkModePresented: Bool = false
    @State var isLandspaceModePresented: Bool = false
    @State var isContentsModePresented: Bool = false
    @State var isColorStylePresented: Bool = false

    // MARK: Clock

    @State var isTimeFormatPresented: Bool = false

    // MARK: Pomodoro

    @State var isFocusPresented: Bool = false
    @State var isShortBreakPresented: Bool = false
    @State var isLongBreakPresented: Bool = false

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
            SettingsUIContentsModeView(isPresented: $isContentsModePresented)
        }, customize: customize)
        .popup(isPresented: $isColorStylePresented, view: {
            SettingsColorStyleView(isPresented: $isColorStylePresented)
        }, customize: customize)

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

        // MARK: About

        .sheet(isPresented: $isAboutPresented) {
            AboutView(isPresented: $isAboutPresented)
        }

        .navigationViewStyle(.stack)
        .introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
            print(type(of: $0)) // UINavigationController
            ui.setupNavigationBar($0.navigationBar)
        }
    }

    var scrollView: some View {
        GeometryReader { proxy in
            ScrollView {
                SettingsProCell(action: {
                    isPaywallPresented = true
                })
                SettingsAppearanceSection(
                    isPaywallPresented: $isPaywallPresented,
                    isDarkModePresented: $isDarkModePresented,
                    isLandspaceModePresented: $isLandspaceModePresented,
                    isContentsModePresented: $isContentsModePresented,
                    isColorStylePresented: $isColorStylePresented
                )

                SettingsClockSection(
                    isPaywallPresented: $isPaywallPresented,
                    isTimeFormatPresented: $isTimeFormatPresented
                )
                .environmentObject(ClockManager.shared)

                SettingsPomodoroSection(
                    isPaywallPresented: $isPaywallPresented,
                    isFocusPresented: $isFocusPresented,
                    isShortBreakPresented: $isShortBreakPresented,
                    isLongBreakPresented: $isLongBreakPresented
                )
                .environmentObject(PomodoroManager.shared)

                SettingsSection(
                    title: R.string.localizable.other(),
                    items: [
                        SettingsItem(type: .popup(R.string.localizable.rate(), nil), action: goToRate),
                        SettingsItem(type: .popup(R.string.localizable.about(), nil), action: {
                            isAboutPresented = true
                        })
                    ]
                )

                Color.clear
                    .height(proxy.safeAreaInsets.bottom)
                    .padding(.vertical, .large)
            }
            .font(.headline)
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(UIManager.shared.color.background)
        .navigationTitle(R.string.localizable.settings())
        .navigationBarItems(leading: Button(action: {
            isPresented = false
        }, label: {
            Image(systemName: "xmark")
                .font(.subheadline)
        }).tintColor(UIManager.shared.color.secondaryLabel))
    }

    func customize<PopupContent: View>(parameters: Popup<PopupContent>.PopupParameters) -> Popup<PopupContent>.PopupParameters {
        parameters
            .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: true))
            .position(.bottom)
            .appearFrom(.bottom)
            .dragToDismiss(true)
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
