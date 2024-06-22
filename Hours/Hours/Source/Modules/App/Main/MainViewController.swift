//
//  MainViewController.swift
//  DotDiary
//
//  Created by 张敏超 on 2024/4/25.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import UIKit

class MainViewController: UIHostingController<MainView> {
    let store: StoreOf<MainFeature>

    init(store: StoreOf<MainFeature>) {
        self.store = store
        let main = MainView(store: store)
        super.init(rootView: main)
    }

//    init(isPaywallPresented: Bool = false) {
//        let main = MainView(
//            store: .init(
//                initialState: .init(isPaywallPresented: isPaywallPresented),
//                reducer: { MainFeature() }
//            )
//        )
//        super.init(rootView: main)
//    }

    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIManager.shared.uiBackground

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

//        store.send(.didLoad)
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
