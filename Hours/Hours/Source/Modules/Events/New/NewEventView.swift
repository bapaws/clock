//
//  NewEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import HoursShare
import RealmSwift
import SwiftUI

struct NewEventView: View {
    var event: EventEntity?

    @State private var emoji: String = ""
    @State private var title: String
    @State private var category: CategoryEntity?

    @State private var isEmojiPresented = false
    @State private var isCategoryPresented = false

    @State private var createNameAttempts = 0
    @State private var createCategoryAttempts = 0

    @FocusState private var isFocused

    @Environment(\.dismiss) private var dismiss

    init(event: EventEntity? = nil, category: CategoryEntity? = nil) {
        self.event = event
        self._emoji = .init(initialValue: event?.emoji ?? "")
        self._title = .init(initialValue: event?.name ?? "")
        self._category = .init(initialValue: category ?? event?.category)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event == nil ? R.string.localizable.newEvent() : R.string.localizable.editEvent())
                .font(.title)
                .foregroundStyle(ui.primary)
                .padding()

            NewItemView(title: R.string.localizable.category()) {
                if let category = category {
                    CategoryView(category: category)
                } else {
                    Text(R.string.localizable.selectCategory())
                        .foregroundStyle(Color.placeholderText)
                }
            }
            .changeEffect(.shake(rate: .fast), value: createCategoryAttempts)
            .onTapGesture {
                isCategoryPresented.toggle()
            }

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

            NewItemView(title: R.string.localizable.eventName()) {
                TextField(R.string.localizable.pleaseEnter(), text: $title)
                    .focused($isFocused)
            }
            .changeEffect(.shake(rate: .fast), value: createNameAttempts)
            .onTapGesture {
                isFocused.toggle()
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

                Button(action: newEvent, label: {
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

        .sheet(isPresented: $isCategoryPresented) {
            SelectCategoryView(selectedCategory: $category)
                .sheetStyle()
        }
    }

    func newEvent() {
        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            createNameAttempts += 1
            return
        }

        guard let category else {
            createCategoryAttempts += 1
            return
        }

        defer { dismiss() }

        Task {
            if var event {
                event.emoji = emoji
                event.name = title
                await AppRealm.shared.writeEvent(event, addTo: category)

                AppManager.shared.updateCalendarEvents(by: event)

                return
            }

            // 保存创建任务对象
            let hex = await AppRealm.shared.nextHex
            let event = EventEntity(emoji: emoji, name: name, hex: hex)
            await AppRealm.shared.writeEvent(event, addTo: category)
        }
    }
}

#Preview {
    NewEventView()
}
