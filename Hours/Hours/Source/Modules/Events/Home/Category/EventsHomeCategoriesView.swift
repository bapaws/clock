//
//  EventsHomeCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/12.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

struct DragRelocateDelegate: DropDelegate {
    enum Move: Int {
        case up, down
    }

    var updated: (Move) -> Void

    func dropEntered(info: DropInfo) {
        debugPrint("dropEntered")
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("update location.x is \(info.location.x)")

        if info.location.y < cellHeight / 2 {
            updated(.up)
        } else {
            updated(.down)
        }

        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        true
    }
}

struct EventsHomeCategoriesView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeCategoriesFeature>

    var body: some View {
        WithPerceptionTracking {
            ForEach(store.categories) { category in
                Section {
                    ForEach(category.events) { event in
                        itemView(for: event)
                    }
                    .padding(.horizontal)

                    // 在尾部添加一定的空间区域，让界面和谐
                    ui.background.height(8)
                } header: {
                    header(for: category)
                }
            }
        }
    }

    func header(for category: CategoryEntity) -> some View {
        EventsHeaderView(category: category) { category in
            store.send(.newEventTapped(category))
        }
        .contentShape(Rectangle())
        // 先调用 menu 的修改器，长按时不会出现圆角的情况
        .contextMenu { menuItems(for: category) }
        .onDrag {
            store.send(.onCategoryDrag(category))
            return NSItemProvider(object: category.id as NSString)
        }
        .onDrop(
            of: [.directory],
            delegate: DragRelocateDelegate {
                store.send(.onCategoryDropUpdate(category, $0), animation: .default)
            }
        )
        .cornerRadius(16)
    }

    func itemView(for event: EventEntity) -> some View {
        WithPerceptionTracking {
            EventItemView(event: event) {
                store.send(.onTimerStarted($0), animation: .default)
            }
            // 先调用 menu 的修改器，长按时不会出现圆角的情况
            .contextMenu { menuItems(for: event) }
            .onTapGesture {
                store.send(.onEventTapped(event))
            }
            .onDrag {
                store.send(.onEventDrag(event))
                return NSItemProvider(object: event.id as NSString)
            }
            .onDrop(
                of: [.text],
                delegate: DragRelocateDelegate {
                    store.send(.onEventDropUpdate(event, $0), animation: .default)
                }
            )
            .cornerRadius(16)

            .alert($store.scope(state: \.alert, action: \.alert))
        }
    }

    @ViewBuilder func menuItems(for event: EventEntity) -> some View {
        WithPerceptionTracking {
            Button {
                store.send(.newRecordTapped(event))
            } label: {
                Label(R.string.localizable.newRecord(), systemImage: "plus")
            }
            Button {
                store.send(.onTimerStarted(event))
            } label: {
                Label(R.string.localizable.startTimer(), systemImage: "play")
            }
            Divider()

            Button(action: {
                store.send(.archiveEvent(event))
            }) {
                Label(R.string.localizable.archive(), systemImage: "archivebox")
            }

            Button(role: .destructive) {
                store.send(.deleteEvent(event))
            } label: {
                Label(R.string.localizable.delete(), systemImage: "trash")
            }
        }
    }

    @ViewBuilder func menuItems(for category: CategoryEntity) -> some View {
        WithPerceptionTracking {
            Button {
                store.send(.newEventTapped(category))
            } label: {
                Label(R.string.localizable.newEvent(), systemImage: "plus")
            }
            Divider()

            Button(action: {
                store.send(.archiveCategory(category), animation: .default)
            }) {
                Label(R.string.localizable.archive(), systemImage: "archivebox")
            }

            Button(role: .destructive) {} label: {
                Label(R.string.localizable.delete(), systemImage: "trash")
                if !category.events.isEmpty {
                    Text(R.string.localizable.deleteEventsFirst())
                }
            }
            .disabled(!category.events.isEmpty)
        }
    }
}

#Preview {
    EventsHomeCategoriesView(
        store: StoreOf<EventsHomeCategoriesFeature>(
            initialState: .init(),
            reducer: { EventsHomeCategoriesFeature() }
        )
    )
}
