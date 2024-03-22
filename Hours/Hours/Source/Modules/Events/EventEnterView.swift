//
//  EventEnterView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/8.
//

import HoursShare
import SwiftUI
import MCEmojiPicker

struct EventEnterView: View {
    static let height: CGFloat = 54

    @Binding var taskName: String
    @Binding var category: CategoryObject?
    @Binding var emoji: String

    @FocusState.Binding var isFocused: Bool
    var onSubmit: () -> Void

    @State var isSubmitDisabled = true
    @State var isEmojiPickerPresented = false

    var body: some View {
        VStack(spacing: 0) {
            if isFocused {
                CategoryPickerView(categorys: DBManager.default.categorys) { category in
                    self.category = category
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.25)))
            }
            
            Divider()

            HStack {
                if let category = category {
                    Button {
                        isFocused.toggle()
                    } label: {
                        CategoryIconView(category: category)
                    }
                }

                TextField("What are you focusing on?", text: $taskName)
                    .frame(height: EventEnterView.height)
                    .focused($isFocused)
                    .onSubmit(onSubmit)
                    .onChange(of: taskName) { newValue in
                        isSubmitDisabled = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    }

                Button(action: onSubmit) {
                    let hex = DBManager.default.nextHex
                    Image(systemName: "play")
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding(4)
                        .font(.callout)
                        .foregroundStyle(hex.onPrimary)
                        .background {
                            Circle()
                                .fill(hex.primary)
                        }

                }
                .disabled(isSubmitDisabled)
            }
            .frame(height: EventEnterView.height)
            .padding(.horizontal)
            .onTapGesture {
                isFocused = true
            }
        }
        .background(.systemBackground)
    }
}

#Preview {
    @FocusState<Bool> var isFocused: Bool
    return EventEnterView(taskName: .constant(""), category: .constant(nil), emoji: .constant("😄"), isFocused: $isFocused, onSubmit: {})
}
