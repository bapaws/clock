//
//  ArchivedEventsViewModel.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/11.
//

import Foundation
import HoursShare
import OrderedCollections
import RealmSwift
import SwiftUI

class ArchivedEventsViewModel: ObservableObject {
    private var token: NotificationToken?
    @Published var categories = OrderedDictionary<CategoryObject, Results<EventObject>>()

    init() {
        let realm = DBManager.default.realm
        let objects = realm.objects(CategoryObject.self).where {
            $0.events[keyPath: \.archivedAt] != nil
        }

        token = objects.observe { [weak self] change in
            switch change {
            case .initial(let collectionType):
                self?.setupCategories(collectionType)
            case .update(let collectionType, let deletions, let insertions, let modifications):
                withAnimation {
                    self?.setupCategories(collectionType)
                }
            case .error(let error):
                print(error)
            }
        }
    }

    deinit {
        token?.invalidate()
    }

    func setupCategories(_ objects: Results<CategoryObject>) {
        categories.removeAll()
        for obj in objects {
            let events = obj.events.where { $0.archivedAt != nil }
            if !events.isEmpty {
                categories[obj] = events
            }
        }
    }

    func unarchiveCategory(_ category: CategoryObject) {
        guard let category = category.thaw(), let realm = category.realm else { return }

        realm.writeAsync {
            category.archivedAt = nil
            for event in category.events {
                event.archivedAt = nil
            }
        }
    }

    func unarchiveEvent(_ event: EventObject) {
        guard let event = event.thaw(), let realm = event.realm else { return }

        realm.writeAsync {
            event.archivedAt = nil
        }
    }
}
