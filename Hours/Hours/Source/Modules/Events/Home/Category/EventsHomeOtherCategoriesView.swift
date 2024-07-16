//
//  EventsHomeOtherCategoriesView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/12.
//

import ComposableArchitecture
import HoursShare
import SwiftUI
import SwiftUIX

struct EventsHomeOtherCategoriesView: View {
    @Perception.Bindable var store: StoreOf<EventsHomeOtherCategoriesFeature>
    var body: some View {
        WithPerceptionTracking {
            ForEach(store.categories) { category in
                WithPerceptionTracking {
                    EventsHeaderView(category: category) { category in
                        store.send(.newEventTapped(category))
                    }
                    // 先调用 menu 的修改器，长按时不会出现圆角的情况
                    .contextMenu { menuItems(for: category) }
                    .cornerRadius(16)
                    .padding(.bottom)
                    .alert($store.scope(state: \.alert, action: \.alert))
                }
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
            Button {
                store.send(.newCategoryTapped(category))
            } label: {
                Label(R.string.localizable.editCategory(), systemImage: "pencil")
            }
            Divider()

            Button(action: {
                store.send(.archiveCategory(category))
            }) {
                Label(R.string.localizable.archive(), systemImage: "archivebox")
            }

            Button(role: .destructive) {
                store.send(.deleteCategory(category))
            } label: {
                Label(R.string.localizable.delete(), systemImage: "trash")
                if category.eventTotalCount != 0 {
                    Text(R.string.localizable.deleteEventsFirst())
                }
            }
            .disabled(category.eventTotalCount != 0)
        }
    }
}

#Preview {
    EventsHomeOtherCategoriesView(
        store: .init(initialState: .init(), reducer: {
            EventsHomeOtherCategoriesFeature()
        })
    )
}
