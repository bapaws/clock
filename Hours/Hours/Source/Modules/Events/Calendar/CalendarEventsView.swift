//
//  CalendarEventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/17.
//

import ComposableArchitecture
import HoursShare
import Pow
import SwiftUI
import SwiftUIX

struct CalendarEventsView: View {
    @Perception.Bindable var store: StoreOf<CalendarEventsFeature>
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ui.background

                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(L10n.startTime)
                                    .font(.caption2)
                                    .foregroundStyle(Color.tertiaryLabel)
                                DatePicker("", selection: $store.startAt, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)

                            VStack(alignment: .leading) {
                                Text(" ")
                                    .font(.caption2)
                                Text("~")
                            }
                            .frame(width: 54)

                            VStack(alignment: .leading) {
                                Text(L10n.endTime)
                                    .font(.caption2)
                                    .foregroundStyle(Color.tertiaryLabel)
                                DatePicker("", selection: $store.endAt, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .height(54)
                        .padding()

                        List(store.categories) { category in
                            let isShrinked = store.shrinkCategoryIDs.contains(category.id)
                            HStack {
                                if let selected = store.selectedCategories[id: category.id] {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(selected.isAllEventSelected ? category.primary : Color.tertiaryLabel)
                                } else {
                                    Image(systemName: "circle")
                                }
                                Text(category.title)
                                Spacer()

                                Button {
                                    store.send(.shrinkCategory(category), animation: .default)
                                } label: {
                                    Image(systemName: "chevron.down.circle")
                                        .rotationEffect(.degrees(isShrinked ? -90 : 0))
                                        .padding(.leading, .large)
                                }
                                .buttonStyle(.plain)
                            }
                            .id(category.id)
                            .padding(.vertical, .extraSmall)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.send(.onCategoryTapped(category), animation: .default)
                            }

                            if !isShrinked {
                                ForEach(category.events) { event in
                                    HStack {
                                        Group {
                                            if let selected = store.selectedCategories[id: category.id], selected.selectedEventIDs.contains(event.id) {
                                                Image(systemName: "checkmark.circle.fill")
                                            } else {
                                                Image(systemName: "circle")
                                            }
                                        }
                                        .foregroundStyle(event.primary)
                                        Text(event.title)
                                        Spacer()
                                    }
                                    .id(event.id)
                                    .padding(.leading)
                                    .padding(.vertical, .extraSmall)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        store.send(.onEventTapped(event), animation: .default)
                                    }
                                }
                            }
                        }
                        .emptyStyle(isEmpty: store.categories.isEmpty)
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(ui.background)
                    }
                    .safeAreaInset(edge: .bottom) {
                        Button {
                            store.send(.startImporting, animation: .default)
                        } label: {
                            HStack(spacing: 16) {
                                if store.isImporting {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                }
                                if store.isLoading {
                                    Text(L10n.loading)
                                } else if store.isImporting {
                                    Text(L10n.importing)
                                } else {
                                    Text(L10n.startImporting)
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 54, maxHeight: 54)
                            .foregroundStyle(.white)
                        }
                        .background(store.isLoading || store.isImporting ? Color.systemGray3 : ui.primary)
                        .cornerRadius(16)
                        .disabled(store.isLoading || store.isImporting)
                        .buttonStyle(DefaultButtonStyle())
                        .changeEffect(
                            .shine.delay(0.15),
                            value: !store.isLoading,
                            isEnabled: !store.isLoading
                        )
                        .padding()
                    }
                }
                .background(ui.background)
                .navigationTitle(L10n.importFromCalendar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            store.send(.close)
                        } label: {
                            Image(systemName: "xmark")
                                .padding(.vertical)
                                .padding(.trailing)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button {
                                store.send(.onImportRecordsToggle)
                            } label: {
                                if store.isImportRecords {
                                    Label(L10n.importRecords, systemImage: "checkmark")
                                } else {
                                    Text(L10n.importRecords)
                                }
                            }
                            Divider()

                            Button(L10n.selectAll) {
                                store.send(.selectAll, animation: .default)
                            }
                            Button(L10n.unselectAll) {
                                store.send(.unselectAll, animation: .default)
                            }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .padding(.vertical)
                                .padding(.leading)
                        }
                    }
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

#Preview {
    CalendarEventsView(
        store: .init(
            initialState: .init(
                categories: IdentifiedArrayOf<CategoryEntity>(
                    uniqueElements: CategoryEntity.random(count: 10)
                )
            ),
            reducer: { CalendarEventsFeature() }
        )
    )
}
