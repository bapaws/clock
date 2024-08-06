//
//  ImportDefaultView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/31.
//

import ComposableArchitecture
import Perception
import SwiftUI
import SwiftUIX

struct ImportDefaultView: View {
    let store: StoreOf<ImportDefaultFeature>

    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                ZStack(alignment: .bottom) {
                    ui.background

                    List(store.categories) { category in
                        WithPerceptionTracking {
                            let isShrinked = store.shrinkCategoryIDs.contains(category.id)
                            let selected = store.selectedCategories[id: category.id]
                            HStack {
                                if let selected, selected.isAllEventDisable {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.tertiaryLabel)
                                    Text(category.title)
                                        .foregroundStyle(Color.tertiaryLabel)
                                } else if let selected, selected.isAllEventSelected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(category.primary)
                                    Text(category.title)
                                } else if let selected, !selected.selectedEventIDs.isEmpty {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.tertiaryLabel)
                                    Text(category.title)
                                } else {
                                    Image(systemName: "circle")
                                    Text(category.title)
                                }
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
                                if let selected, selected.isAllEventDisable { return }
                                store.send(.onCategoryTapped(category), animation: .default)
                            }

                            if !isShrinked {
                                ForEach(category.events) { event in
                                    WithPerceptionTracking {
                                        HStack {
                                            if let selected, selected.disableEventIDs.contains(event.id) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(Color.tertiaryLabel)
                                                Text(event.title)
                                                    .foregroundStyle(Color.tertiaryLabel)
                                            } else if let selected, selected.selectedEventIDs.contains(event.id) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundStyle(event.primary)
                                                Text(event.title)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundStyle(event.primary)
                                                Text(event.title)
                                            }

                                            Spacer()
                                        }
                                        .id(event.id)
                                        .padding(.leading)
                                        .padding(.vertical, .extraSmall)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if let selected, selected.disableEventIDs.contains(event.id) { return }
                                            store.send(.onEventTapped(category, event), animation: .default)
                                        }
                                    }
                                }
                            }
                        }
                    }
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
                            if store.isImporting {
                                Text(L10n.importing)
                            } else {
                                Text(L10n.startImporting)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 54, maxHeight: 54)
                        .foregroundStyle(.white)
                    }
                    .background(store.isImporting ? Color.systemGray3 : ui.primary)
                    .cornerRadius(16)
                    .disabled(store.isImporting)
                    .buttonStyle(DefaultButtonStyle())
                    .padding()
                }
                .background(ui.background)
                .navigationTitle(L10n.importDefault)
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
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    ImportDefaultView(
        store: .init(initialState: .init(), reducer: { ImportDefaultFeature() })
    )
}
