//
//  EventProvider.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation
import HoursShare
import RealmSwift

struct EventProvider: DynamicOptionsProvider {
    @MainActor func results() async throws -> ItemCollection<String> {
        let sections: [ItemSection] = await AppRealm.shared.getAllUnarchivedCategories()
            .compactMap { category in
                let items: [IntentItem<String>] = category.events.map { event in
                    Item(event._id.stringValue, title: LocalizedStringResource(stringLiteral: event.title))
                }
                if #available(iOS 16.4, *) {
                    return ItemSection(
                        LocalizedStringResource(stringLiteral: category.title),
                        items: items
                    )
                } else {
                    return ItemSection(
                        title: LocalizedStringResource(stringLiteral: category.title),
                        items: items
                    )
                }
            }
        return ItemCollection(sections: sections)
    }
}
