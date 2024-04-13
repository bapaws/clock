//
//  EventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/5.
//

import ClockShare
import HoursShare
import Realm
import RealmSwift
import SwiftUI
import SwiftUIX

struct EventsView<MenuItems: View>: View {
    @ObservedResults(CategoryObject.self)
    var categorys

    @State private var selectEvent: EventObject?
    @State private var newRecordSelectEvent: EventObject?

    var menuItems: ((EventObject) -> MenuItems)?
    var newEventAction: ((CategoryObject) -> Void)?
    var playAction: ((EventObject) -> Void)?
    var tapAction: ((EventObject) -> Void)?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(categorys, id: \.id) { category in
                    LazyVStack(spacing: 16) {
                        HStack {
                            CategoryView(category: category)
                            Spacer()
                            if let action = newEventAction {
                                Button(action: {
                                    action(category)
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }

                        ForEach(category.events) { event in
                            let itemView = EventItemView(event: event, playAction: playAction)
                                .onTapGesture {
                                    tapAction?(event)
                                }
                            if let menuItems = menuItems {
                                itemView.contextMenu {
                                    menuItems(event)
                                }
                            } else {
                                itemView
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding()
        }
        .background(ui.background)
    }

//    func itemView(for event: EventObject) -> some View {
//        var itemView: some View = EventItemView(event: event, playAction: playAction)
//            .onTapGesture {
//                tapAction?(event)
//            }
//        if let menuItems = menuItems {
//            itemView = itemView.contextMenu {
//                menuItems(event)
//            }
//        } else {
//            itemView
//        }
//    }
}

extension EventsView where MenuItems == Never {
    init(
        newEventAction: ((CategoryObject) -> Void)? = nil,
        playAction: ((EventObject) -> Void)? = nil,
        tapAction: ((EventObject) -> Void)? = nil
    ) {
        self.newEventAction = newEventAction
        self.playAction = playAction
        self.tapAction = tapAction
    }
}

#Preview {
    EventsView(menuItems: { _ in
        Group {
            Button(action: {}) {
                Label(R.string.localizable.delete(), systemImage: "trash")
            }
            Button(action: {}) {
                Label(R.string.localizable.newRecord(), systemImage: "plus")
            }
            Button(action: {}) {
                Label("Delete", systemImage: "minus.circle")
            }
        }
    }
    )
}
