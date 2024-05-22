//
//  SplashViewController.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/13.
//

import ClockShare
import HoursShare
import SwiftUI
import UIKit

class SplashViewController: UIHostingController<SplashView> {
    var ui: UIManager { UIManager.shared }

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            if AppManager.shared.onboardingIndices.isEmpty {
                self?.replaceRootViewController()
            } else {
                self?.replaceOnboardingView()
            }
        }
    }

    func replaceOnboardingView() {
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }
        window.rootViewController = UIHostingController(rootView: OnboardingView())
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }

    func replaceRootViewController() {
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }
        let main = MainViewController()
        let root = UINavigationController(rootViewController: main)
        window.rootViewController = root
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {})
    }
}
