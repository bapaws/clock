//
//  EventsHomeViewModel.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/11.
//

import Collections
import Foundation
import HoursShare
import RealmSwift
import SwiftUI

class EventsHomeViewModel: ObservableObject {
    private var token: NotificationToken?
    @Published var categories = OrderedDictionary<CategoryObject, Results<EventObject>>()
    @Published var otherCategories = [CategoryObject]()

    @Published var isOtherCategoriesShow = false

    init() {
        let realm = DBManager.default.realm
        let objects = realm.objects(CategoryObject.self)

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
        otherCategories.removeAll()
        for obj in objects {
            let events = obj.events.where { $0.archivedAt == nil }
            if events.isEmpty {
                otherCategories.append(obj)
            } else {
                categories[obj] = events
            }
        }
    }

    func deleteEvent(_ event: EventEntity) {
        Task {
            await AppRealm.shared.deleteEvent(event)
        }
    }

    func archiveEvent(_ event: EventEntity) {
        Task {
            await AppRealm.shared.archiveEvent(event)
        }
    }
}
