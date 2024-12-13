//
//  QuickWidgetEntity.swift
//  HoursShare
//
//  Created by 张敏超 on 2024/12/11.
//

import RealmSwift

public struct QuickWidgetEntity: Identifiable, Equatable, Codable, Hashable, Sendable {
    public static let defaultID = "6759936086813351bd7a31d7"

    public var _id = ObjectId.generate()
    public var title: String = ""
    public var index: Int = 0
    public var categories: [QuickCategoryEntity] = []

    public var selectedCategoryID: String?

    public init(_id: ObjectId = ObjectId.generate(), title: String = "", index: Int = 0, categories: [QuickCategoryEntity] = []) {
        self._id = _id
        self.title = title
        self.index = index
        self.categories = categories
        self.selectedCategoryID = categories.first?.id
    }

    public var selectedEvents: [QuickEventEntity]? {
        categories.first(where: { $0.id == selectedCategoryID })?.events ?? categories.first?.events
    }
}

public extension QuickWidgetEntity {
    var id: String { _id.stringValue }
}
