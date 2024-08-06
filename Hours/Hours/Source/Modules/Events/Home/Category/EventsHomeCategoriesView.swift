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
//        print("update location.x is \(info.location.x)")

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
                    // 如果只是用 event 的 id 作为 view 的 id，会造成重用时不刷新 view
                    // 导致分类不对等不符合预期的结果
                    ForEach(category.events, id: { $0.id + category.id }) { event in
                        itemView(for: event)
                    }
                    .padding(.horizontal)

                    // 在尾部添加一定的空间区域，让界面和谐
                    ui.background.height(12)
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
                Label(L10n.newRecord, systemImage: "plus")
            }
            Button {
                store.send(.onTimerStarted(event))
            } label: {
                Label(L10n.startTimer, systemImage: "play")
            }
            Divider()

            Button(action: {
                store.send(.editEventTapped(event))
            }) {
                Label(L10n.edit, systemImage: "pencil")
            }

            Button(action: {
                store.send(.archiveEvent(event))
            }) {
                Label(L10n.archive, systemImage: "archivebox")
            }

            Divider()

            Button(role: .destructive) {
                store.send(.deleteEvent(event))
            } label: {
                Label(L10n.delete, systemImage: "trash")
            }
        }
    }

    @ViewBuilder func menuItems(for category: CategoryEntity) -> some View {
        WithPerceptionTracking {
            Button {
                store.send(.newEventTapped(category))
            } label: {
                Label(L10n.newEvent, systemImage: "plus")
            }
            Button {
                store.send(.newCategoryTapped(category))
            } label: {
                Label(L10n.editCategory, systemImage: "pencil")
            }
            Divider()

            Button(action: {
                store.send(.archiveCategory(category), animation: .default)
            }) {
                Label(L10n.archive, systemImage: "archivebox")
            }

            Button(role: .destructive) {} label: {
                Label(L10n.delete, systemImage: "trash")
                if category.eventTotalCount != 0 {
                    Text(L10n.deleteEventsFirst)
                }
            }
            .disabled(category.eventTotalCount != 0)
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
