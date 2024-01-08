//
//  ProManager.swift
//  Shared
//
//  Created by 张敏超 on 2023/11/24.
//

import Foundation

public struct PurchasedProduct: Codable {
    public var identifier: String?
    public var localizedTitle: String?
    public var expiryDate: Date?

    enum CodingKeys: String, CodingKey {
        case identifier
        case localizedTitle
        case expiryDate
    }

    public init(identifier: String?, localizedTitle: String?, expiryDate: Date? = nil) {
        self.identifier = identifier
        self.localizedTitle = localizedTitle
        self.expiryDate = expiryDate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        localizedTitle = try container.decodeIfPresent(String.self, forKey: .localizedTitle)
        expiryDate = try container.decodeIfPresent(Date.self, forKey: .expiryDate)
    }

    public var isLifetime: Bool {
        identifier == "com.bapaws.desktopclock.lifetime"
    }
}

open class ProManager: NSObject {
    private static let shared = ProManager()

    open class var `default`: ProManager { shared }

    public var isPro: Bool {
//        #if DEBUG
//        true
//        #else
        purchasedProduct != nil
//        #endif
    }

    @Published open var purchasedProduct: PurchasedProduct? {
        didSet {
            Storage.default.purchasedProduct = purchasedProduct
        }
    }

    public override init() {
        super.init()
        purchasedProduct = Storage.default.purchasedProduct
    }

    public func expireAt(date: Date) -> Bool {
        #if DEBUG
        return false
        #else
        guard let purchased = purchasedProduct else { return true }

        if purchased.isLifetime {
            return false
        }
        if let expiryDate = purchased.expiryDate, date.timeIntervalSince1970 < expiryDate.timeIntervalSince1970 {
            return false
        }
        return true
        #endif
    }
}
