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
import UIOnboarding

class SplashViewController: UIHostingController<SplashView> {
    var ui: UIManager { UIManager.shared }

    private lazy var onboardingConfiguration: UIOnboardingViewConfiguration = .init(
        appIcon: R.image.launchImage()!,
        firstTitleLine: NSMutableAttributedString(
            string: R.string.localizable.welcomeTo(),
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .largeTitle),
                .foregroundColor: ui.uiLabel
            ]
        ),
        secondTitleLine: NSMutableAttributedString(
            string: R.string.localizable.appName(),
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .title1),
                .foregroundColor: ui.uiPrimary
            ]
        ),
        features: [
            UIOnboardingFeature(
                icon: UIImage(systemName: "calendar")!,
                iconTint: .systemPink,
                title: R.string.localizable.calendarTitle(),
                description: ""
            )
        ],
        buttonConfiguration: UIOnboardingButtonConfiguration(
            title: R.string.localizable.continue(),
            backgroundColor: ui.uiPrimary
        )
    )

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

extension SplashViewController: UIOnboardingViewControllerDelegate {
    func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {}
}
