//
//  NewCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/10.
//

import ComposableArchitecture
import HoursShare
import MCEmojiPicker
import Pow
import RealmSwift
import SwiftUI

struct NewCategoryView: View {
    @Perception.Bindable var store: StoreOf<NewCategoryFeature>

    @State private var isEmojiPresented = false

    @FocusState private var isFocused

    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 16) {
                Text(L10n.newCategory)
                    .font(.title)
                    .foregroundStyle(ui.primary)
                    .padding()

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
                        ColorIconView(hex: store.hex)
                    }
                }
                .onTapGesture {
                    store.send(.onColorPicked)
                }

                NewItemView(title: L10n.categoryName) {
                    WithPerceptionTracking {
                        TextField(L10n.pleaseEnter, text: $store.title)
                            .focused($isFocused)
                    }
                }
                .changeEffect(.shake, value: store.createAttempts)
                .onTapGesture {
                    if isEmojiPresented {
                        isEmojiPresented.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            isFocused.toggle()
                        }
                    } else {
                        isFocused.toggle()
                    }
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

            .sheet(item: $store.scope(state: \.colorPick, action: \.colorPick)) { store in
                ColorPickView(store: store)
                    .sheetStyle()
            }
        }
    }
}

#Preview {
    NewCategoryView(
        store: StoreOf<NewCategoryFeature>(initialState: .init(), reducer: { NewCategoryFeature() })
    )
}
