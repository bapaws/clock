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
    @State var offsetX: CGFloat = 0
    @State private var currentIndex = 1
    @StateObject var page: Page = .withIndex(1)

    @State private var isTabHidden = false

    @State private var isSettingsPresented = false

    @EnvironmentObject var ui: UIManager

    var icon: IconStyle {
        UIManager.shared.icon
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                UIManager.shared.color.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    UIManager.shared.color.background.frame(height: proxy.safeAreaInsets.top + 8)
                    if !isTabHidden {
                        HStack {
                            PageControl(index: $currentIndex, offsetX: $offsetX)
                                .frame(width: min(icon.tabItemWidth * 3, ceil(proxy.size.width / 4 * 3)), height: icon.tabItemHeight)
                                .foregroundColor(ui.color.secondaryLabel)
                                .background(ui.color.background)
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
            .background(ui.color.background)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation {
                    isTabHidden.toggle()
                }
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(isPresented: $isSettingsPresented)
        }
    }

    @ViewBuilder func pager(with safeAreaInsets: EdgeInsets) -> some View {
        Pager(page: page, data: ClockType.allCases, id: \.self) { index in
            pageContent(at: index)
                .padding(EdgeInsets(top: 0, leading: safeAreaInsets.leading, bottom: safeAreaInsets.bottom, trailing: safeAreaInsets.trailing))
        }
        .onDraggingBegan {
            withAnimation {
                isTabHidden = false
            }
        }
        .onDraggingChanged { value in
            print(value)
            offsetX = value
        }
        .onDraggingEnded {
            print("========\(offsetX)")
            withAnimation {
                offsetX = 0
            }
        }
        .onPageWillChange { index in
            print(index)
            withAnimation {
                currentIndex = index
            }
        }
    }

    @ViewBuilder func pageContent(at index: ClockType) -> some View {
        switch index {
        case .pomodoro:
            PomodoroView()
        case .clock:
            ClockView()
        case .timer:
            TimerView()
        }
    }

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
        .foregroundColor(UIManager.shared.color.secondaryLabel)
        .padding(.top, safeAreaInsets.top)
        .padding(.bottom, safeAreaInsets.bottom + 8)
        .padding(.trailing, safeAreaInsets.trailing)
    }
}

#Preview {
    MainView()
        .environmentObject(UIManager.shared)
}
