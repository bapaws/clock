//
//  EventsViewModel.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/10.
//

import Collections
import Foundation
import HoursShare
import RealmSwift
import SwiftUI

class EventsViewModel: ObservableObject {
    private var token: NotificationToken?
    @Published var categories = OrderedDictionary<CategoryObject, Results<EventObject>>()

    init() {
        let realm = DBManager.default.realm
        let objects = realm.objects(CategoryObject.self)

        token = objects.observe { [weak self] change in
            switch change {
            case .initial(let collectionType):
                for obj in collectionType {
                    self?.categories[obj] = obj.events.where { $0.archivedAt == nil }
                }
            case .update(let collectionType, let deletions, let insertions, let modifications):
                withAnimation {
                    for index in deletions {
                        self?.categories.remove(at: index)
                    }
                    for index in insertions {
                        let key = collectionType[index]
                        let value = key.events.where { $0.archivedAt == nil }
                        self?.categories.updateValue(value, forKey: key, insertingAt: index)
                    }
                    for index in modifications {
                        let key = collectionType[index]
                        let value = key.events.where { $0.archivedAt == nil }
                        self?.categories.updateValue(value, forKey: key)
                    }
                }
            case .error(let error):
                print(error)
            }
        }
    }

    deinit {
        token?.invalidate()
    }
}
