//
//  OnboardingView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import ClockShare
import Foundation
import HealthKitUI
import HoursShare
import SwiftUI
import SwiftUIX

struct OnboardingView: View {
    private let indicesWidth: CGFloat = 120

    @State private var currentPageIndex = 0

    @State private var isHealthPresented = true

    var onFinished: (() -> Void)?

    private var onboardingIndices: [OnboardingIndices] {
        AppManager.shared.onboardingIndices
    }

    private var index: OnboardingIndices {
        onboardingIndices[currentPageIndex]
    }

    var body: some View {
        VStack(spacing: 24) {
            PaginationView(onboardingIndices, id: \.self, showsIndicators: false) { index in
                VStack {
                    switch index {
                    case .welcome:
                        OnboardingWelcomeView()
                    case .calendar:
                        OnboardingCalendarView()
                    case .appScreenTime:
                        OnboardingAppScreenTimeView()
                    case .health:
                        OnboardingHealthView()
                    case .statistics:
                        OnboardingStatisticsView()
                    }
                }
                .padding(.large)
            }
            .currentPageIndex($currentPageIndex.animation())

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

                let indexWidth = indicesWidth / CGFloat(onboardingIndices.count)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .width(indexWidth)
                    .offset(x: indexWidth * CGFloat(currentPageIndex))
                    .animation(.spring, value: currentPageIndex)
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
        case .health:
            isHealthPresented.toggle()
            AppManager.shared.requestHealthAccess { granted in
                if granted {
                    AppManager.shared.isAutoSyncHealth = true
                } else {
                    Toast.show(R.string.localizable.calendarNotAccess())
                }
                setupLater()
            }
        case .calendar:
            AppManager.shared.requestCalendarAccess { granted in
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
        let newPageIndex = currentPageIndex + 1
        if onboardingIndices.count > newPageIndex {
            Storage.default.store.set(index.version, forKey: index.storeKey)

            withAnimation { currentPageIndex = newPageIndex }
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

        let main = MainViewController(isPaywallPresented: isPaywallPresented)
        let root = UINavigationController(rootViewController: main)
        window.rootViewController = root
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}

#Preview {
    OnboardingView()
}
