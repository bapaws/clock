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
    @Environment(\.scenePhase) var scenePhase

    @State var didFinishLoad: Bool = false

    var body: some Scene {
        WindowGroup {
            group
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                // In iOS 13+, idle timer needs to be set in scene to override default
                UIApplication.shared.isIdleTimerDisabled = AppManager.shared.idleTimerDisabled
            case .inactive: break
            case .background: break
            @unknown default: print("ScenePhase: unexpected state")
            }
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

        // MARK: -

        UIApplication.shared.addObserver(self, forKeyPath: "idleTimerDisabled", options: .new, context: nil)

        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIManager.shared.landspaceMode.support
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.isIdleTimerDisabled = AppManager.shared.idleTimerDisabled
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let idleTimerDisabled = AppManager.shared.idleTimerDisabled
        if let newValue = change?[.newKey] as? Bool, newValue != idleTimerDisabled {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }
}
