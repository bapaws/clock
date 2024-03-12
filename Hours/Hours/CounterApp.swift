//
//  CounterApp.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import HoursShare
import RealmSwift
import SwiftUI
import WidgetKit
import SwiftDate

@main
struct CounterApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase

    @State var didFinishLoad: Bool = false
    var body: some Scene {
        WindowGroup {
            group
                .foregroundColor(Color(white: 0.2))
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                if #available(iOS 16.0, *) {
                    UNUserNotificationCenter.current().setBadgeCount(0)
                } else {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                // In iOS 13+, idle timer needs to be set in scene to override default
                UIApplication.shared.isIdleTimerDisabled = AppManager.shared.idleTimerDisabled
                WidgetCenter.shared.reloadTimelines(ofKind: "HoursWidget")
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
        let tabBar = UITabBar.appearance()
        tabBar.unselectedItemTintColor = UIColor.opaqueSeparator
        tabBar.isTranslucent = false

        SwiftDate.defaultRegion = .current

        DBManager.default.setup()

        DispatchQueue.main.async {
            UIManager.shared.setupUI()
        }

        ProManager.setup()

        // MARK: Observer

        UIApplication.shared.addObserver(self, forKeyPath: "idleTimerDisabled", options: .new, context: nil)

        // MARK: Notification

        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }

        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIManager.shared.landspaceMode.support
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let idleTimerDisabled = AppManager.shared.idleTimerDisabled
        if let newValue = change?[.newKey] as? Bool, newValue != idleTimerDisabled {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }
}
