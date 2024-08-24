//
//  NewRecordEndAtPickerView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/22.
//

import SwiftDate
import SwiftUI
import SwiftUIX

struct NewRecordEndAtPickerView: View {
    let startAt: Date
    @Binding var dateTime: Date

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text(L10n.endTime)
                    .font(.title)
                    .foregroundStyle(ui.primary)
                    .padding(.top)
                Spacer()
            }

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(app.recordDurations, id: \.self) { duration in
                        Button {
                            dateTime = startAt.addingTimeInterval(TimeInterval(duration * 60))
                            dismiss()
                        } label: {
                            Text((duration * 60 * 1000).shortTimeLengthText)
                                .padding(.vertical, .small)
                                .padding(.horizontal, .small)
                                .background(ui.primary.opacity(0.5))
                                .cornerRadius(8)
                                .foregroundStyle(.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke()
                                        .foregroundStyle(ui.primary)
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .height(72)

            DatePicker(
                L10n.endTime,
                selection: $dateTime,
                in: startAt...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .font(.title, weight: .black)
            .datePickerStyle(.wheel)
            .labelsHidden()

            HStack(spacing: 16) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text(L10n.cancel)
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(ui.primary)
                .cornerRadius(16)

                Button(action: {
                    dismiss()
                }, label: {
                    Text(L10n.save)
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
        .padding(.vertical, .large)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .background(ui.background)
    }
}

#Preview {
    NewRecordEndAtPickerView(
        startAt: Date.now.addingTimeInterval(-3600),
        dateTime: .constant(.now)
    )
}
