//
//  ProManager.swift
//  CalendarArt
//
//  Created by 张敏超 on 2023/11/19.
//

import ClockShare
import Foundation
import RevenueCat

typealias ProCompletionHandler = (PublicError?) -> Void

class ProManager: ClockShare.ProManager, ObservableObject {
    private static let shared = ProManager()
    override class var `default`: ProManager { shared }

    public private(set) var availablePackages = [Package]()
    private var allPackages = [Package]()

    public var containsSubscriptions: Bool {
        availablePackages.contains {
            $0.storeProduct.productIdentifier == "com.bapaws.desktopclock.yearly" || $0.storeProduct.productIdentifier == "com.bapaws.desktopclock.monthly"
        }
    }

    override init() {
        super.init()
    }

    public static func setup() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(
            withAPIKey: "appl_sgCmJGKWPQGNeTsZLKcZPihgddB",
            appUserID: AppIdentifier.shared.anonymous
        )

        // 先信赖本地存储，后面验证
        shared.purchasedProduct = Storage.default.purchasedProduct
        shared.getOfferings { _ in
            // 主要作用是接收用户订单变化
            // 获取产品信息之后再进行设置，避免保存后没有产品信息，导致显示问题
            Purchases.shared.delegate = shared

            // 获取后调用，可以正确保存会员名称
            Purchases.shared.getCustomerInfo { customerInfo, _ in
                shared.savePurchased(customerInfo: customerInfo)
            }
        }
    }

    public func getOfferings(completion: @escaping ProCompletionHandler) {
        if !availablePackages.isEmpty {
            return completion(nil)
        }

        Purchases.shared.getOfferings { [weak self] offerings, error in
            guard let offerings = offerings else { return completion(error) }
            self?.allPackages.removeAll(keepingCapacity: true)
            self?.availablePackages.removeAll(keepingCapacity: true)

            let all = offerings.all.map { _, value in
                value.availablePackages
            }.flatMap { packages in
                packages
            }.uniques(by: \.storeProduct.productIdentifier)
            self?.allPackages += all

            #if DEBUG
            self?.availablePackages += all
            #else
            if let packages = offerings.current?.availablePackages {
                self?.availablePackages += packages
            } else {
                self?.availablePackages += all
            }
            #endif

            completion(nil)
        }
    }

    private func savePurchased(customerInfo: CustomerInfo?) {
        guard let info = customerInfo, !info.entitlements.active.isEmpty else {
            purchasedProduct = nil
            return
        }

        var productIdentifier: String?
        for sub in info.activeSubscriptions {
            productIdentifier = sub
        }
        for transaction in info.nonSubscriptions {
            productIdentifier = transaction.productIdentifier
        }

        // id 相同不再设置，直接返回
        if productIdentifier == purchasedProduct?.identifier {
            return
        }

        let product = allPackages.first(where: {
            $0.storeProduct.productIdentifier == productIdentifier
        })
        let purchased = PurchasedProduct(
            identifier: productIdentifier,
            localizedTitle: product?.storeProduct.localizedTitle,
            expiryDate: info.latestExpirationDate
        )
        purchasedProduct = purchased
    }
}

// MARK: -

extension ProManager {
    func purchase(index: Int, completion: ProCompletionHandler?) {
        guard index < availablePackages.count else {
            completion?(PublicError(domain: "", code: 404))
            return
        }

        purchase(package: availablePackages[index], completion: completion)
    }

    func purchase(package: Package, completion: ProCompletionHandler?) {
        Purchases.shared.purchase(package: package) { [weak self] _, customerInfo, error, _ in
            self?.savePurchased(customerInfo: customerInfo)
            completion?(error)
        }
    }

    func restorePurchases(completion: ProCompletionHandler?) {
        Purchases.shared.restorePurchases { [weak self] customerInfo, error in
            self?.savePurchased(customerInfo: customerInfo)
            completion?(error)
        }
    }
}

// MARK: -

extension ProManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        savePurchased(customerInfo: customerInfo)
    }

    func purchases(_ purchases: Purchases, readyForPromotedProduct product: StoreProduct, purchase startPurchase: @escaping StartPurchaseBlock) {
//        let proVC = UIStoryboard.instantiateViewController(ProViewController.self)
//        if let topVC = UIApplication.shared.topViewController(), topVC is SplashViewController {
//            topVC.dismiss(animated: false)
//        }
//        UIApplication.shared.topViewController()?.present(proVC, animated: true, completion: {
//            HUD.show(timeout: 90)
//            let block: PurchaseCompletedBlock = { [weak self] _, customerInfo, _, _ in
//                self?.savePurchased(customerInfo: customerInfo)
//                HUD.hide()
//            }
//            startPurchase(block)
//        })
    }
}
