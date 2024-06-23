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
                Text(R.string.localizable.newCategory())
                    .font(.title)
                    .foregroundStyle(ui.primary)
                    .padding()

                NewItemView(title: R.string.localizable.emoji()) {
                    WithPerceptionTracking {
                        if store.emoji.isEmpty {
                            Text(R.string.localizable.pleaseSelect())
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

                NewItemView(title: R.string.localizable.categoryName()) {
                    WithPerceptionTracking {
                        TextField(R.string.localizable.pleaseEnter(), text: $store.title)
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
                        Text(R.string.localizable.cancel())
                            .padding(.vertical, .small)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(ui.primary)
                    .cornerRadius(16)

                    Button {
                        store.send(.save)
                    } label: {
                        Text(R.string.localizable.save())
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
        }
    }
}

#Preview {
    NewCategoryView(
        store: StoreOf<NewCategoryFeature>(initialState: .init(), reducer: { NewCategoryFeature() })
    )
}
