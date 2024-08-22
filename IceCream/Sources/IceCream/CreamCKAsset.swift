import CloudKit
import Foundation

public protocol CreamCKAsset {
    var assetPropertyName: String? { get }
    var asset: CKAsset? { get }
    func parse(ckAsset: CKAsset)
}

public extension CreamCKAsset {
    var assetPropertyName: String? { nil }
    var asset: CKAsset? { nil }
    func parse(ckAsset: CKAsset) {}
}
