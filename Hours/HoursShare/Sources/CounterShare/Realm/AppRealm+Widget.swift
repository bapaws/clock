//
//  AppRealm+Widget.swift
//  HoursShare
//
//  Created by 张敏超 on 2024/12/11.
//

import ClockShare
import RealmSwift
import WidgetKit

public extension AppRealm {
    func setupDefaultWidget() async {
        let realm = await realm
        widgetToken = realm.objects(CategoryObject.self).observe { change in
            var reload = false
            switch change {
            case let .initial(categories):
                if Storage.default.quickLargeWidgets == nil {
                    let quickCategories = self.getQuickCategories(categories: categories, family: WidgetFamily.systemLarge)
                    if !quickCategories.isEmpty {
                        let entity = QuickWidgetEntity(
                            _id: try! ObjectId(string: QuickWidgetEntity.defaultID),
                            title: L10n.default,
                            index: 0,
                            categories: quickCategories
                        )
                        Storage.default.quickLargeWidgets = [entity]

                        reload = true
                    }
                }
                if Storage.default.quickMediumWidgets == nil {
                    let quickCategories = self.getQuickCategories(categories: categories, family: WidgetFamily.systemMedium)
                    if !quickCategories.isEmpty {
                        let entity = QuickWidgetEntity(
                            _id: try! ObjectId(string: QuickWidgetEntity.defaultID),
                            title: L10n.default,
                            index: 0,
                            categories: quickCategories
                        )
                        Storage.default.quickLargeWidgets = [entity]

                        reload = true
                    }
                }

            case let .update(categories, deletions: deletions, insertions: insertions, modifications: modifications):
                debugPrint(categories, deletions, insertions, modifications)
                if let quickMediumWidgets = Storage.default.quickLargeWidgets {
                    Storage.default.quickLargeWidgets = self.update(quickWidgets: quickMediumWidgets, categories: categories)
                }
                if let quickMediumWidgets = Storage.default.quickMediumWidgets {
                    Storage.default.quickMediumWidgets = self.update(quickWidgets: quickMediumWidgets, categories: categories)
                }
            case let .error(err):
                debugPrint(err)
            }
            // 刷新小组件
            if reload {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    private func getQuickCategories(categories: Results<CategoryObject>, family: WidgetFamily) -> [QuickCategoryEntity] {
        let objects = categories
            .where { $0.archivedAt == nil && $0.deletedAt == nil }
            .sorted(by: \.index)
        var entities = [QuickCategoryEntity]()
        for object in objects {
            var entity = QuickCategoryEntity(object: object)
            entity.events = object.events
                .where { $0.archivedAt == nil && $0.deletedAt == nil }
                .sorted(by: \.index)
                .prefix(family.quickMaxEventCount)
                .map { QuickEventEntity(object: $0) }
            // 当不存在时，直接返回
            if entity.events.isEmpty { continue }
            entities.append(entity)

            if entities.count == family.quickMaxCategoryCount {
                return entities
            }
        }
        return entities
    }

    private func update(quickWidgets: [QuickWidgetEntity], categories: Results<CategoryObject>) -> [QuickWidgetEntity] {
        var widgets = quickWidgets
        let widgetCount = widgets.enumerated().reversed().count
        for widgetIndex in 0..<widgetCount {
            let reversedWidgetIndex = widgetCount - 1 - widgetIndex
            let widget = widgets[reversedWidgetIndex]
            let categoryCount = widget.categories.count
            for categoryIndex in 0..<categoryCount {
                let reversedCategoryIndex = categoryCount - 1 - categoryIndex
                let category = widget.categories[reversedCategoryIndex]
                if let categoryObject = categories.where({ $0._id == category._id && $0.deletedAt == nil && $0.archivedAt == nil }).first {
                    let eventCount = category.events.count
                    for eventIndex in 0..<eventCount {
                        let reversedEventIndex = eventCount - 1 - eventIndex
                        let event = category.events[reversedEventIndex]
                        if let eventObject = categoryObject.events.where({ $0._id == event._id && $0.deletedAt == nil && $0.archivedAt == nil }).first {
                            widgets[reversedWidgetIndex].categories[reversedCategoryIndex].events[reversedEventIndex] = QuickEventEntity(object: eventObject)
                        } else {
                            widgets[reversedWidgetIndex].categories[reversedCategoryIndex].events.remove(at: reversedEventIndex)
                            if widgets[reversedWidgetIndex].categories[reversedCategoryIndex].events.isEmpty {
                                widgets[reversedWidgetIndex].categories.remove(at: reversedCategoryIndex)
                                if widgets[reversedWidgetIndex].categories.isEmpty {
                                    widgets.remove(at: reversedWidgetIndex)
                                }
                            }
                        }
                    }
                } else {
                    widgets[reversedWidgetIndex].categories.remove(at: reversedCategoryIndex)
                    if widgets[reversedWidgetIndex].categories.isEmpty {
                        widgets.remove(at: reversedWidgetIndex)
                    }
                }
            }
        }
        return widgets
    }
}
