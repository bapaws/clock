//
//  UIApplication.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/11/13.
//

import ClockShare
import SwiftUI
import UIKit

public extension UIApplication {
    var navigationController: UINavigationController? {
        UIApplication.shared.firstKeyWindow?.rootViewController as? UINavigationController
    }

    func pushView<Destination: View>(_ content: Destination, animated: Bool = true) {
        let hostingController = UIHostingController(rootView: content)

        navigationController?.pushViewController(hostingController, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            hostingController.navigationItem.backButtonTitle = ""
        }
    }
}
