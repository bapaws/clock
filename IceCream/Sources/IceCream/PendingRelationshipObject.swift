//
//  PendingRelationshipObject.swift
//  IceCream
//
//  Created by 张敏超 on 2024/10/8.
//

import Foundation
import RealmSwift

class PendingRelationshipObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId

    /// 对象的 ID
    @Persisted var objectID: String
    /// 对象的类型名
    @Persisted var objectClassName: String
    /// 属性的 ID
    @Persisted var propertyID: String
    /// 对象的属性名
    @Persisted var propertyName: String
    /// 对象的属性类型名
    @Persisted var propertyObjectClassName: String
}
