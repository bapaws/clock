//
//  EventProvider.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import Foundation
import AppIntents
import HoursShare

struct EventProvider: DynamicOptionsProvider {
    @MainActor func results() async throws -> ItemCollection<String> {
        let sections: [ItemSection] = DBManager.default.categorys
            .map { category in
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
