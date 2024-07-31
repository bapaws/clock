//
//  NewEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftUI

struct NewEventView: View {
    @Perception.Bindable var store: StoreOf<NewEventFeature>

    @State private var isEmojiPresented = false
    @FocusState private var isFocused

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 16) {
                Text(store.event == nil ? L10n.newEvent : L10n.editEvent)
                    .font(.title)
                    .foregroundStyle(ui.primary)
                    .padding()

                NewItemView(title: L10n.category) {
                    WithPerceptionTracking {
                        if let category = store.category {
                            CategoryView(category: category)
                        } else {
                            Text(L10n.selectCategory)
                                .foregroundStyle(Color.placeholderText)
                        }
                    }
                }
                .changeEffect(.shake(rate: .fast), value: store.createCategoryAttempts)
                .onTapGesture {
                    store.send(.selectCategoryTapped)
                }

                NewItemView(title: L10n.eventName) {
                    WithPerceptionTracking {
                        ColorIconView(hex: store.hex)
                    }
                }
                .onTapGesture {
                    store.send(.onColorPicked)
                }

                NewItemView(title: L10n.emoji) {
                    WithPerceptionTracking {
                        if store.emoji.isEmpty {
                            Text(L10n.pleaseSelect)
                                .foregroundStyle(Color.placeholderText)
                        } else {
                            Text(store.emoji)
                        }
                    }
                }
                .emojiPicker(isPresented: $isEmojiPresented, selectedEmoji: $store.emoji, arrowDirection: .down)
                .onTapGesture {
                    if isFocused {
                        isFocused.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isEmojiPresented.toggle()
                        }
                    } else {
                        isEmojiPresented.toggle()
                    }
                }

                NewItemView(title: L10n.eventName) {
                    WithPerceptionTracking {
                        TextField(L10n.pleaseEnter, text: $store.title)
                            .focused($isFocused)
                    }
                }
                .changeEffect(.shake(rate: .fast), value: store.createNameAttempts)
                .onTapGesture {
                    isFocused.toggle()
                }

                HStack(spacing: 16) {
                    Button {
                        store.send(.cancel)
                    } label: {
                        Text(L10n.cancel)
                            .padding(.vertical, .small)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(ui.primary)
                    .cornerRadius(16)

                    Button {
                        store.send(.save)
                    } label: {
                        Text(L10n.save)
                            .padding(.vertical, .small)
                            .frame(maxWidth: .infinity)
                    }
                    .tint(ui.primary)
                    .foregroundStyle(Color.white)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(16)
                    .disabled(store.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || store.isLoading)
                }
                .padding(.top)

                Spacer()
            }
            .padding()
            .padding(.vertical, .extraLarge)
            .background(ui.background)

            .sheet(item: $store.scope(state: \.selectCategory, action: \.selectCategory)) { store in
                SelectCategoryView(store: store)
                    .sheetStyle()
            }

            .sheet(item: $store.scope(state: \.colorPick, action: \.colorPick)) { store in
                RGBPicker(store: store)
                    .sheetStyle()
            }
        }
    }
}

#Preview {
    NewEventView(
        store: StoreOf<NewEventFeature>(initialState: .init()) { NewEventFeature() }
    )
}
