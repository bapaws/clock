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
    var event: EventObject?

    @State private var title: String
    @State private var category: CategoryObject?

    @State private var isEventPresented = false
    @State private var isCategoryPickerPresented = false

    @FocusState private var isFocused

    @Environment(\.dismiss) private var dismiss

    init(event: EventObject? = nil, category: CategoryObject? = nil) {
        self.event = event
        self._title = .init(initialValue: event?.name ?? "")
        self._category = .init(initialValue: category ?? event?.category)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(R.string.localizable.newEvent())
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
            .onTapGesture {
                withAnimation {
                    isCategoryPickerPresented.toggle()
                }
            }

            if isCategoryPickerPresented {
                CategoryPickerView(categorys: DBManager.default.categorys) { object in
                    category = object
                    withAnimation {
                        isCategoryPickerPresented.toggle()
                    }
                }
                .cornerRadius(16)
            }

            NewItemView(title: R.string.localizable.eventName()) {
                TextField(R.string.localizable.pleaseEnter(), text: $title)
                    .focused($isFocused)
            }
            .onTapGesture {
                isFocused.toggle()
            }

            HStack(spacing: 16) {
                Button(action: {
                    category = nil
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
    }

    func newEvent() {
        guard let category = category?.thaw(), let realm = category.realm?.thaw() else { return }

        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return
        }

        defer { dismiss() }
        if let event = event?.thaw() {
            realm.writeAsync {
                event.name = title
                if category != event.category, let index = event.category.events.firstIndex(of: event) {
                    event.category.events.remove(at: index)
                }
                category.events.append(event)
            }
            return
        }

        // 保存创建任务对象
        let hex = DBManager.default.nextHex
        let event = EventObject(name: name, hex: hex)
        realm.writeAsync {
            category.events.append(event)
        }
    }
}

#Preview {
    NewEventView()
}
