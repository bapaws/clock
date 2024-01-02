//
//  DesktopClockApp.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/23.
//

import ClockShare
import RevenueCat
import SwiftUI

@main
struct DesktopClockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var didFinishLoad: Bool = false

    var body: some Scene {
        WindowGroup {
            group
        }
    }

    @ViewBuilder var group: some View {
        if didFinishLoad {
            MainView()
                .environmentObject(AppManager.shared)
                .environmentObject(UIManager.shared)
                .transition(AnyTransition.opacity)
        } else {
            SplashView(didFinishLoad: $didFinishLoad)
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DispatchQueue.main.async {
            UIManager.shared.setupUI()
        }

        ProManager.setup()

        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIManager.shared.landspaceMode.support
    }
}
