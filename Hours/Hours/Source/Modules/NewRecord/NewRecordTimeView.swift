//
//  NewRecordTimeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/11.
//

import SwiftDate
import SwiftUI
import SwiftUIX

struct NewRecordTimeView: View {
    let title: String
    @Binding var dateTime: Date
    var range: PartialRangeFrom<Date>?
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .foregroundStyle(ui.primary)
                    .padding(.top)
                Spacer()
            }

            Group {
                if let range = range {
                    DatePicker(
                        title,
                        selection: $dateTime,
                        in: range,
                        displayedComponents: [.hourAndMinute]
                    )
                } else {
                    DatePicker(
                        title,
                        selection: $dateTime,
                        displayedComponents: [.hourAndMinute]
                    )
                }
            }
            .font(.title, weight: .black)
            .datePickerStyle(.wheel)
            .labelsHidden()

            HStack(spacing: 16) {
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Cancel")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(ui.primary)
                .cornerRadius(16)

                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Save")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .tint(ui.primary)
                .foregroundStyle(Color.white)
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
            }
            .padding(.top)
            Spacer()
        }
        .padding()
        .padding(.vertical, .extraLarge)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .background(ui.background)
    }
}

#Preview {
    NewRecordTimeView(title: "Start Time", dateTime: .constant(.now), isPresented: .constant(false))
}
