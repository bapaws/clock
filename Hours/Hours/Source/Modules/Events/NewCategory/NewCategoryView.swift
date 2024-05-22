//
//  NewCategoryView.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/10.
//

import HoursShare
import MCEmojiPicker
import Pow
import RealmSwift
import SwiftUI

struct NewCategoryView: View {
    var category: CategoryObject?

    @State private var emoji: String = ""
    @State private var title: String = ""

    @State private var isEmojiPresented = false

    @FocusState private var isFocused

    @State private var createAttempts = 0

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(R.string.localizable.newCategory())
                .font(.title)
                .foregroundStyle(ui.primary)
                .padding()

            NewItemView(title: R.string.localizable.emoji()) {
                if emoji.isEmpty {
                    Text(R.string.localizable.pleaseSelect())
                        .foregroundStyle(Color.placeholderText)
                } else {
                    Text(emoji)
                }
            }
            .emojiPicker(isPresented: $isEmojiPresented, selectedEmoji: $emoji, arrowDirection: .down)
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
                TextField(R.string.localizable.pleaseEnter(), text: $title)
                    .focused($isFocused)
            }
            .changeEffect(.shake, value: createAttempts)
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
                Button(action: {
                    dismiss()
                }, label: {
                    Text(R.string.localizable.cancel())
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(ui.primary)
                .cornerRadius(16)

                Button(action: newCategory, label: {
                    Text(R.string.localizable.save())
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .tint(ui.primary)
                .foregroundStyle(Color.white)
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .padding(.vertical, .extraLarge)
        .background(ui.background)
    }

    func newCategory() {
        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            createAttempts += 1
            return
        }

        if let category = category?.thaw() {
            category.realm?.writeAsync {
                category.emoji = emoji
                category.name = title
            }
        } else {
            // 保存创建任务对象
            let realm = DBManager.default.realm
            let hex = DBManager.default.nextHex.thaw()
            realm.writeAsync {
                let newCategory = CategoryObject(hex: hex, emoji: emoji, name: title)
                realm.add(newCategory)
            }
        }

        dismiss()
    }
}

#Preview {
    NewCategoryView(category: CategoryObject(hex: HexObject(hex: "#FEA6ED"), icon: "plus", name: "Sports"))
}
