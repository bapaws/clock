//
//  MainView.swift
//  Clock
//
//  Created by 张敏超 on 2023/12/17.
//

import ClockShare
import Dependencies
import Neumorphic
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
            ZStack(alignment: .top) {
                color.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    color.background.frame(height: proxy.safeAreaInsets.top + 8)
                    if !isTabHidden {
                        HStack {
                            PageControl(index: $currentIndex, offsetX: $offsetX)
                                .frame(width: min(icon.tabItemWidth * 3, ceil(proxy.size.width / 4 * 3)), height: icon.tabItemHeight)
                                .foregroundColor(ui.colors.primary)
                                .background(ui.colors.background)
                                .onChange(of: currentIndex) { newIndex in
                                    withAnimation {
                                        page.update(.new(index: newIndex))
                                    }
                                }
                        }
                    }
                    pager(with: proxy.safeAreaInsets)
                }
                if !isTabHidden {
                    toolbar(with: proxy.safeAreaInsets)
                }
            }
            .contentShape(Rectangle())
            .background(ui.colors.background)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation {
                    isTabHidden.toggle()
                }
            }
        }
        .statusBar(hidden: isTabHidden)
        .foregroundColor(ui.colors.primary)

        // MARK: Present

        .sheet(isPresented: $isSettingsPresented) {
//            #if DEBUG
//            CaptureView()
//            #else
            SettingsView(isPresented: $isSettingsPresented)
                .environmentObject(ProManager.default)
//            #endif
        }
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
        Pager(page: page, data: ClockType.allCases, id: \.self) { index in
            pageContent(at: index)
                .padding(EdgeInsets(top: 0, leading: safeAreaInsets.leading, bottom: safeAreaInsets.bottom, trailing: safeAreaInsets.trailing))
        }
        .allowsDragging(!isTabHidden)
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

    @ViewBuilder func pageContent(at index: ClockType) -> some View {
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
                    .frame(width: icon.tabItemHeight + 16, height: icon.tabItemHeight + 16)
            })
        }
        .font(icon.font)
        .foregroundColor(color.primary)
        .padding(.top, safeAreaInsets.top)
        .padding(.bottom, safeAreaInsets.bottom + 8)
        .padding(.trailing, safeAreaInsets.trailing)
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
