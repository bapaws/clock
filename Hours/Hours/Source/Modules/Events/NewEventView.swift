//
//  NewEventView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import HoursShare
import SwiftUI

struct NewEventView: View {
    @State var title: String = ""
    @Binding var category: CategoryObject?

    @State var isEventPresented = false
    @State var isCategoryPickerPresented = false

    @FocusState var isFocused

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Create Event")
                .font(.title)
                .foregroundStyle(Color.mint)
                .padding()

            NewItemView(title: "Category") {
                if let category = category {
                    CategoryView(category: category)
                } else {
                    Text("Empty")
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

            NewItemView(title: "Event Name") {
                TextField(text: $title)
                    .focused($isFocused)
            }
            .onTapGesture {
                isFocused.toggle()
            }

            HStack(spacing: 16) {
                Button(action: {
                    category = nil
                }, label: {
                    Text("Cancel")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(Color.mint)
                .cornerRadius(16)

                Button(action: newEvent, label: {
                    Text("Save")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .tint(Color.mint)
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
        .background(Color.secondarySystemBackground)
    }

    func newEvent() {
        guard let realm = category?.realm else { return }

        let name = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return
        }

        // 保存创建任务对象
        let hex = DBManager.default.nextHex
        let task = EventObject(name: name, category: category, hex: hex)
        try? realm.write {
            realm.add(task)
        }

        category = nil
    }
}

#Preview {
    NewEventView(category: .constant(CategoryObject(hex: HexObject(hex: "#FEA6ED"), icon: "plus", name: "Sports")))
}
