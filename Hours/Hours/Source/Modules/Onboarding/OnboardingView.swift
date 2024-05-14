//
//  OnboardingView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import ClockShare
import Foundation
import HoursShare
import SwiftUI
import SwiftUIX

enum OnboardingIndices: Int, CaseIterable {
    case welcome, appScreenTime, calendar, statistics

    var version: Int {
        switch self {
        case .welcome:
            1
        case .appScreenTime:
            1
        case .calendar:
            1
        case .statistics:
            1
        }
    }
}

struct OnboardingView: View {
    static let version = 1

    @State private var index: OnboardingIndices = .welcome
    private let indicesWidth: CGFloat = 120

    private var currentPageIndex: Binding<Int> {
        Binding<Int>.init(get: {
            index.rawValue
        }, set: {
            guard let index = OnboardingIndices(rawValue: $0) else { return }
            self.index = index
        })
    }

    var onFinished: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            PaginationView(OnboardingIndices.allCases, id: \.self, showsIndicators: false) { index in
                VStack {
                    switch index {
                    case .welcome:
                        OnboardingWelcomeView()
                    case .calendar:
                        OnboardingCalendarView()
                    case .appScreenTime:
                        OnboardingAppScreenTimeView()
                    case .statistics:
                        OnboardingStatisticsView()
                    }
                }
                .padding(.large)
            }
            .currentPageIndex(currentPageIndex.animation())

            Spacer()

            VStack {
                bottom
            }
            .padding(.large)
        }
        .padding(.top, .extraLarge)
        .background(ui.background)
    }

    @ViewBuilder private var bottom: some View {
        HStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.systemGray5)

                let indexWidth = indicesWidth / CGFloat(OnboardingIndices.allCases.count)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .width(indexWidth)
                    .offset(x: indexWidth * CGFloat(index.rawValue))
                    .animation(.spring, value: index)
            }
            .frame(width: indicesWidth, height: 6)

            Spacer()

            Button {
                `continue`()
            } label: {
                Text(R.string.localizable.continue())
                    .font(.system(.body, design: .default, weight: .bold))
                    .padding(.horizontal, .extraLarge)
                    .frame(height: 54)
                    .foregroundStyle(ui.background)
            }
            .background(ui.primary)
            .cornerRadius(28)
        }

        if index == .welcome {
            ui.background.frame(height: 54)
        } else {
            HStack {
                Spacer()
                Button {
                    setupLater()
                } label: {
                    Text(R.string.localizable.setupLater())
                        .padding(.horizontal, .extraLarge)
                        .frame(height: 54)
                        .foregroundStyle(ui.label)
                }
            }
        }
    }

    private func `continue`() {
        switch index {
        case .calendar:
            AppManager.shared.requestAccess { granted in
                if granted {
                    AppManager.shared.isSyncRecordsToCalendar = true
                } else {
                    Toast.show(R.string.localizable.calendarNotAccess())
                }
                setupLater()
            }
        case .statistics:
            setupLater(isPaywallPresented: true)
        default:
            setupLater()
        }
    }

    private func setupLater(isPaywallPresented: Bool = false) {
        if let newIndex = OnboardingIndices(rawValue: index.rawValue + 1) {
            withAnimation {
                index = newIndex
            }
        } else if let onFinished = onFinished {
            onFinished()
        } else {
            replaceRootViewController(isPaywallPresented: isPaywallPresented)
        }
    }

    private func replaceRootViewController(isPaywallPresented: Bool = false) {
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }

        Storage.default.onboardingVersion = OnboardingView.version

        let main = MainViewController(isPaywallPresented: isPaywallPresented)
        let root = UINavigationController(rootViewController: main)
        window.rootViewController = root
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}

#Preview {
    OnboardingView()
}
