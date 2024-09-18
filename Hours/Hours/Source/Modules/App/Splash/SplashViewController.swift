//
//  SplashViewController.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftUI
import UIKit

class SplashViewController: UIHostingController<SplashView> {
    let store = StoreOf<MainFeature>(
        initialState: .init(),
        reducer: { MainFeature() }
    )

    var ui: UIManager { UIManager.shared }

    var observation: ObservationToken?

    init() {
        let view = SplashView()
        super.init(rootView: view)
    }

    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIManager.shared.uiBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        store.send(.didLoad)

        observation = observe { [weak self] in
            guard let self, store.isLoadCompleted else { return }

            if AppManager.shared.onboardingIndices.isEmpty {
                self.replaceRootViewController()
            } else {
                self.replaceOnboardingView()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observation?.cancel()
    }

    func replaceOnboardingView() {
        #if DEBUG
        let view = OnboardingView(onboardingIndices: OnboardingIndices.allCases)
        #else
        let view = OnboardingView()
        #endif
        let controller = UIHostingController(rootView: view)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .custom
        present(controller, animated: true)
    }

    /// 第一次使用有 Onboarding 时，不调用这个方法
    func replaceRootViewController() {
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }

        let main = MainViewController(store: store)
        let root = UINavigationController(rootViewController: main)
        window.rootViewController = root
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}) { _ in
            /// 除第一次启动新手引导不主动请求权限
            /// 其他 app 启动，主动去请求权限
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                AppManager.shared.requestAccess()
            }
        }
    }
}
