//
//  AppDelegate.swift
//  DotDiary
//
//  Created by 张敏超 on 2024/4/25.
//

import ClockShare
import CloudKit
import HoursShare
import IceCream
import RealmSwift
import SwiftDate
import UIKit

@UIApplicationMain
@MainActor class AppDelegate: UIResponder, UIApplicationDelegate {
    @MainActor func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup Date local
        SwiftDate.defaultRegion = .local

        DispatchQueue.main.async {
            UIManager.shared.setupUI()
        }

        ProManager.setup()

        application.registerForRemoteNotifications()

//        #if DEBUG
//        if #available(iOS 17.0, *) {
//            try? Tips.configure()
//        }
//        #else
//        if #available(iOS 17.0, *), AppManager.shared.launchCount == 0 {
//            try? Tips.configure()
//        }
//        #endif

        Task {
            if AppManager.shared.isICloudSync {
                await AppRealm.shared.setupSyncCloud()
            }
//            await AppRealm.shared.generateRandomRecords()
        }

        AppManager.shared.enableObservedSleepAnalysis()
        AppManager.shared.enableObservedWorkout()

        #if DEBUG
            sendCloudKitDataDidChangeRemotely()
        #endif

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        return UIManager.shared.landspaceMode.support
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo),
           let subscriptionID = notification.subscriptionID,
           IceCreamSubscription.allIDs.contains(subscriptionID)
        {
            NotificationCenter.default.post(
                name: Notifications.cloudKitDataDidChangeRemotely.name,
                object: nil,
                userInfo: userInfo
            )
            return completionHandler(.newData)
        }

        return completionHandler(.noData)
    }

    #if DEBUG
        func sendCloudKitDataDidChangeRemotely() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
                NotificationCenter.default.post(
                    name: Notifications.cloudKitDataDidChangeRemotely.name,
                    object: nil,
                    userInfo: nil
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
                    self?.sendCloudKitDataDidChangeRemotely()
                }
            }
        }
    #endif
}
