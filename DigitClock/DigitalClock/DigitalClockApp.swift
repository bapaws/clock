//
//  DigitalClockApp.swift
//  DigitalClock
//
//  Created by 张敏超 on 2024/1/20.
//

import ClockShare
import DigitalClockShare
import GoogleMobileAds
import RevenueCat
import SwiftUI
import WidgetKit

@main
struct DigitalClockApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase

    @State var didFinishLoad: Bool = false

    var body: some Scene {
        WindowGroup {
            group
                .onOpenURL { url in
                    guard url.scheme == proScheme else { return }
                    purchase()
                }
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
                UIApplication.shared.isIdleTimerDisabled = DigitalAppManager.shared.idleTimerDisabled
                WidgetCenter.shared.reloadAllTimelines()
            case .inactive: break
            case .background: break
            @unknown default: print("ScenePhase: unexpected state")
            }
        }
    }

    @ViewBuilder var group: some View {
        if didFinishLoad {
            DigitalMainView()
                .environmentObject(DigitalAppManager.shared)
                .environmentObject(UIManager.shared)
                .transition(AnyTransition.opacity)
        } else {
            SplashView(didFinishLoad: $didFinishLoad)
        }
    }

    func purchase() {
        guard let package = DigitalProManager.default.lifetimePackage else { return }

        HUD.show()
        DigitalProManager.default.purchase(package: package) { error in
            HUD.hide()
            if let error = error {
                print(error)
                Toast.show(error.localizedDescription)
            } else {
                Toast.show(R.string.localizable.congratulations())
            }
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        DispatchQueue.main.async {
            UIManager.shared.setupUI()
        }

        DigitalProManager.setup()

        // MARK: Observer

        UIApplication.shared.addObserver(self, forKeyPath: "idleTimerDisabled", options: .new, context: nil)

        // MARK: Notification

        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }

        if !ProManager.default.isPro {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }

        return true
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        UIManager.shared.landspaceMode.support
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let idleTimerDisabled = DigitalAppManager.shared.idleTimerDisabled
        if let newValue = change?[.newKey] as? Bool, newValue != idleTimerDisabled {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }
}
