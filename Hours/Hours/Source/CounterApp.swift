//
//  CounterApp.swift
//  Counter
//
//  Created by 张敏超 on 2024/3/3.
//

import HealthKit
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import WidgetKit

@main
struct CounterApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase

    @Environment(\.colorScheme) var colorScheme

    @State var ui: UIManager = .shared
    @State var app: AppManager = .shared

    @State var didFinishLoad: Bool = false
    var body: some Scene {
        WindowGroup {
            group
                .foregroundStyle(ui.colors.label)
                .background(ui.colors.background)
                .environmentObject(ui)
                .environmentObject(app)
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        return UIManager.shared.landspaceMode.support
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        let idleTimerDisabled = AppManager.shared.idleTimerDisabled
        if let newValue = change?[.newKey] as? Bool, newValue != idleTimerDisabled {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }

//    func getAllWorkoutTypes() {
//        var workoutTypes: [HKWorkoutActivityType] = [
//            .americanFootball, .archery, .australianFootball, .badminton, .baseball, .basketball, .bowling, .boxing, .climbing, .cricket, .crossTraining, .curling, .cycling, .dance, .danceInspiredTraining, .elliptical, .equestrianSports, .fencing, .fishing, .functionalStrengthTraining, .golf, .gymnastics, .handball, .hiking, .hockey, .hunting, .lacrosse, .martialArts, .mindAndBody, .mixedCardio, .paddleSports, .play, .preparationAndRecovery, .racquetball, .rowing, .rugby, .running, .sailing, .skatingSports, .snowSports, .soccer, .softball, .squash, .stairClimbing, .surfingSports, .swimming, .tableTennis, .tennis, .trackAndField, .traditionalStrengthTraining, .volleyball, .walking, .waterFitness, .waterPolo, .waterSports, .wrestling, .yoga, .barre, .coreTraining, .crossCountrySkiing, .downhillSkiing, .flexibility, .highIntensityIntervalTraining, .jumpRope, .kickboxing, .pilates, .snowboarding, .stairs, .stepTraining, .wheelchairWalkPace, .wheelchairRunPace, .taiChi, .mixedCardio, .handCycling, .discSports, .fitnessGaming, .cardioDance, .socialDance, .pickleball, .cooldown, .swimBikeRun, .transition
//        ]
//
//        if #available(iOS 17.0, *) {
//            workoutTypes.append(.underwaterDiving)
//        }
//
//
//        for workoutType in workoutTypes {
//            print(workoutType.rawValue)
//        }
//    }
}
