//
//  MainView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/17.
//

import ClockShare
import DigitalClockShare
import PopupView
import SwiftUI
import SwiftUIPager
import SwiftUIX

struct MainView: View {
    // MARK: Pager

    @State var offsetX: CGFloat = 0
    @State private var currentIndex = 1
    @StateObject var page: Page = .withIndex(1)

    // MARK: UI

    @State private var isTabHidden = false

    @State private var isSettingsPresented = false

    @Environment(\.colorScheme) var colorScheme

    // MARK: Manager

    @StateObject var clock = ClockManager.shared
    @StateObject var pomodoro = PomodoroManager.shared
    @StateObject var timer = TimerManager.shared

    @EnvironmentObject var ui: UIManager

    var body: some View {
        let body = GeometryReader { proxy in
            let isPortrait = proxy.size.width < proxy.size.height
            ZStack(alignment: .top) {
                color.background.ignoresSafeArea()
                pager(with: proxy.safeAreaInsets)
            }
            .contentShape(Rectangle())
            .background(ui.colors.background)
            .ignoresSafeArea()
            .onTapGesture {
                isSettingsPresented = true
            }

            // MARK: - Settings

            .popup(isPresented: $isSettingsPresented) {
//                CaptureView()
                let width = isPortrait ? proxy.size.width : proxy.size.width * 0.6
                let height = isPortrait ? 420 : (proxy.size.height + proxy.safeAreaInsets.bottom + proxy.safeAreaInsets.top)
                SettingsView(
                    isPortrait: isPortrait,
                    safeAreaInsets: proxy.safeAreaInsets,
                    isPresented: $isSettingsPresented,
                    pageIndex: $currentIndex
                )
                .frame(width: width, height: height)
                .environmentObject(ProManager.default)
            } customize: {
                $0
                    .animation(.spring())
                    .isOpaque(true)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.2))
                    .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: true))
                    .position(isPortrait ? .bottom : .trailing)
                    .appearFrom(isPortrait ? .bottom : .right)
            }
        }
        .statusBar(hidden: isTabHidden)
        .foregroundColor(ui.colors.primary)

        // MARK: Present

        .onChange(of: isSettingsPresented) { isPresented in
            if isPresented {
                AppManager.shared.suspend()
            } else {
                AppManager.shared.resume()
            }
        }
        .onChange(of: currentIndex) { index in
            DispatchQueue.main.async {
                AppManager.shared.onPageWillChange(index: index)
            }
            withAnimation {
                page.update(.new(index: index))
            }
        }

        // MARK: Listen

        .onChange(of: colorScheme) { newValue in
            ui.setupColors(scheme: newValue)
        }

        if #available(iOS 16.0, *) {
            body.persistentSystemOverlays(isTabHidden ? .hidden : .automatic)
        } else {
            body
        }
    }

    // MARK: - Pager

    @ViewBuilder func pager(with safeAreaInsets: EdgeInsets) -> some View {
        Pager(page: page, data: AppPage.allCases, id: \.self) { index in
            pageContent(at: index)
                .padding(EdgeInsets(top: 0, leading: safeAreaInsets.leading, bottom: safeAreaInsets.bottom, trailing: safeAreaInsets.trailing))
                .contentShape(Rectangle())
        }
        .onDraggingChanged { value in
            offsetX = value
        }
        .onDraggingEnded {
            withAnimation {
                offsetX = 0
            }
        }
        .onPageWillChange { index in
            withAnimation {
                currentIndex = index
            }
        }
    }

    // MARK: - Content

    @ViewBuilder func pageContent(at index: AppPage) -> some View {
        switch index {
        case .pomodoro:
            PomodoroView(isTabHidden: $isTabHidden)
                .environmentObject(pomodoro)
        case .clock:
            ClockView()
                .environmentObject(clock)
        case .timer:
            TimerView(isTabHidden: $isTabHidden)
                .environmentObject(timer)
        }
    }

    // MARK: - Toolbar

    @ViewBuilder func toolbar(with safeAreaInsets: EdgeInsets) -> some View {
        HStack {
            Spacer()
            Button(action: {
                isSettingsPresented = true
            }, label: {
                Text(icon.settings)
                    .frame(height: icon.tabItemHeight + 16)
            })
        }
        .font(icon.font)
        .foregroundColor(color.primary)
        .padding(.top, safeAreaInsets.top)
        .padding(.bottom, safeAreaInsets.bottom + 8)
        .padding(.trailing, safeAreaInsets.trailing)
        .padding(.trailing)
    }
}

// MARK: Getter

extension MainView {
    var icon: IconStyle { ui.icon }
    var color: Colors { ui.colors }
}

#Preview {
    MainView()
        .environmentObject(UIManager.shared)
}
