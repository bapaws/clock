//
//  MainViewController.swift
//  DotDiary
//
//  Created by 张敏超 on 2024/4/25.
//

import HoursShare
import SwiftUI
import UIKit

class MainViewController: UIHostingController<MainView> {
    init(isPaywallPresented: Bool = false) {
        let main = MainView(isPaywallPresented: isPaywallPresented)
        super.init(rootView: main)
    }

    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIManager.shared.uiBackground

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
