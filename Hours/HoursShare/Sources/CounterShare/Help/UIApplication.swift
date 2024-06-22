//
//  UIApplication.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/11/13.
//

import ClockShare
import ComposableArchitecture
import SwiftUI
import UIKit

public class HostingSwiftUIViewController<Content: View>: UIHostingController<Content> {


    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

@MainActor
public extension UIApplication {
    var navigationController: UINavigationController? {
        UIApplication.shared.firstKeyWindow?.rootViewController as? UINavigationController
    }

    func pushView<Destination: View>(_ content: Destination, title: String?, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: content)
        hostingController.title = title

        navigationController?.pushViewController(hostingController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            hostingController.navigationItem.backButtonTitle = ""
        }
    }

    func popView(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}

private enum ApplicationKey: DependencyKey {
    static let liveValue = UIApplication.shared
    static var testValue = UIApplication.shared
}

public extension DependencyValues {
    var application: UIApplication {
        get { self[ApplicationKey.self] }
        set { self[ApplicationKey.self] = newValue }
    }
}
