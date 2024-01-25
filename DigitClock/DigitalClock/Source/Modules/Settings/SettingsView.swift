//
//  SettingsView.swift
//  DigitalClock
//
//  Created by 张敏超 on 2023/12/25.
//

import ClockShare
import DigitalClockShare
import PopupView
import RevenueCat
import SwiftUI
import SwiftUIX

struct SettingsView: View {
    let isPortrait: Bool
    let safeAreaInsets: EdgeInsets
    @Binding var isPresented: Bool

    @Binding var pageIndex: Int

    // MARK: Clock

    @State var isTimeFormatPresented: Bool = false

    // MARK: Pomodoro

    @State var isFocusPresented: Bool = false
    @State var isShortBreakPresented: Bool = false
    @State var isLongBreakPresented: Bool = false

    // MARK: General Settings

    @State var isGeneralSettingsPresented = false

    @EnvironmentObject var ui: UIManager

    var body: some View {
        VStack(spacing: 0) {
            Picker("Page", selection: $pageIndex.animation()) {
                Text(R.string.localizable.pomodoro())
                    .tag(0)
                    .contentShape(Rectangle())
                Text(R.string.localizable.clock())
                    .tag(1)
                    .contentShape(Rectangle())
                Text(R.string.localizable.timer())
                    .tag(2)
                    .contentShape(Rectangle())
            }
            .contentShape(Rectangle())
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, .small)

            // MARK: Page Type

            switch pageIndex {
            case 0:
                SettingsPomodoroSection(
                    isFocusPresented: $isFocusPresented,
                    isShortBreakPresented: $isShortBreakPresented,
                    isLongBreakPresented: $isLongBreakPresented
                )
                .environmentObject(PomodoroManager.shared)
            case 2:
                SettingsTimerSection()
                    .environmentObject(TimerManager.shared)
            default:
                SettingsClockSection(
                    isTimeFormatPresented: $isTimeFormatPresented
                )
                .environmentObject(ClockManager.shared)
            }

            Spacer()
            if !ProManager.default.isPro {
#if DEBUG
                BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                    .frame(BannerAd.size)
#else
                BannerAd(unitID: "ca-app-pub-3709047998636393/8407088534")
                    .frame(BannerAd.size)
#endif
            } else {
                Rectangle().fill(Color.separator).height(0.5)
                    .padding(.horizontal)
            }

            SettingsNavigateCell(title: R.string.localizable.settings()) {
                isGeneralSettingsPresented = true
            }
            .padding(.horizontal)
        }
        .padding(.bottom, safeAreaInsets.bottom)
        .padding(.trailing, isPortrait ? 0 : 36)
        .foregroundStyle(ui.colors.primary)
        .background(ui.colors.background)
        .font(.system(.body, design: .rounded), weight: .ultraLight)

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

        .sheet(isPresented: $isGeneralSettingsPresented) {
            GeneralSettingsView(isPresented: $isGeneralSettingsPresented)
        }
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
}

#Preview {
    SettingsView(isPortrait: false, safeAreaInsets: EdgeInsets.zero, isPresented: Binding<Bool>.constant(true), pageIndex: Binding.constant(1))
}
