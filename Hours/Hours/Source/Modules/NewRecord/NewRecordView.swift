//
//  NewRecordView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/11.
//

import HoursShare
import PopupView
import Pow
import SwiftUI
import SwiftUIX
import UIKit

struct NewRecordView: View {
    @State private var record: RecordObject?

    @State private var event: EventObject?
    @State private var startAt: Date
    @State private var endAt: Date

    @State private var isEventPresented = false
    @State private var isStartTimePresented = false
    @State private var isEndTimePresented = false

    @State private var createAttempts = 0

    @Environment(\.dismiss) var dismiss

    init(event: EventObject? = nil, startAt: Date, endAt: Date) {
        self.event = event
        self.startAt = startAt
        self.endAt = endAt
    }

    init(record: RecordObject) {
        self.record = record

        self.event = record.event
        self.startAt = record.startAt
        self.endAt = record.endAt
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(record == nil ? R.string.localizable.newRecord() : R.string.localizable.editRecord())
                    .font(.title)
                    .foregroundStyle(ui.primary)
                Spacer()
                if let category = event?.categorys.first {
                    CategoryView(category: category)
                }
            }
            .padding()

            NewItemView(title: R.string.localizable.event()) {
                if let event = event {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(event.primary)
                        .width(4)
                    Text(event.name)
                } else {
                    Text("Select")
                        .foregroundStyle(Color.secondaryLabel)
                }
            }
            .onTapGesture {
                isEventPresented = true
            }
            .changeEffect(.shake(rate: .fast), value: createAttempts)

            NewItemView(title: R.string.localizable.startTime()) {
                Text(startAt.to(format: "MMMddHH:mm"))
                    .monospacedDigit()
            }
            .onTapGesture {
                isStartTimePresented = true
            }

            NewItemView(title: R.string.localizable.endTime()) {
                Text(endAt.to(format: "MMMddHH:mm"))
                    .monospacedDigit()
            }
            .onTapGesture {
                isEndTimePresented = true
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

                Button(action: newRecord, label: {
                    Text(R.string.localizable.save())
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .tint(ui.primary)
                .foregroundStyle(Color.white)
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                .disabled(event == nil)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .padding(.vertical, .extraLarge)
        .background(ui.background)

        // MARK: Start Time

        .sheet(isPresented: $isStartTimePresented, content: {
            if #available(iOS 16.4, *) {
                NewRecordTimeView(title: "Start Time", dateTime: $startAt, isPresented: $isStartTimePresented)
                    .presentationCornerRadius(32)
            } else {
                NewRecordTimeView(title: "Start Time", dateTime: $startAt, isPresented: $isStartTimePresented)
            }
        })
        .onChange(of: startAt) { newValue in
            if endAt < newValue {
                endAt = newValue.addingTimeInterval(3600)
            }
        }

        // MARK: End Time

        .sheet(isPresented: $isEndTimePresented, content: {
            if #available(iOS 16.4, *) {
                NewRecordTimeView(title: "End Time", dateTime: $endAt, range: startAt..., isPresented: $isEndTimePresented)
                    .presentationCornerRadius(32)
            } else {
                NewRecordTimeView(title: "End Time", dateTime: $endAt, range: startAt..., isPresented: $isEndTimePresented)
            }
        })

        // MARK: Event

        .sheet(isPresented: $isEventPresented, content: {
            let view = EventsView(tapAction: { event in
                self.event = event
                isEventPresented = false
            })
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            if #available(iOS 16.4, *) {
                view
                    .presentationCornerRadius(32)
                    .presentationContentInteraction(.scrolls)
            } else {
                view
            }
        })
    }

    func customize<PopupContent: View>(parameters: Popup<PopupContent>.PopupParameters) -> Popup<PopupContent>.PopupParameters {
        parameters
            .type(.floater(verticalPadding: 0, horizontalPadding: 0, useSafeAreaInset: false))
            .position(.bottom)
            .appearFrom(.bottom)
            .closeOnTapOutside(true)
            .animation(.spring(duration: 0.3))
    }

    func newRecord() {
        guard let event = event?.thaw(), let realm = event.realm else {
            createAttempts += 1
            return
        }

        let thawedRecord = record?.thaw()
        let newRecord = RecordObject(creationMode: record?.creationMode ?? .enter, startAt: startAt, endAt: endAt)
        realm.writeAsync {
            if let thawedRecord = thawedRecord {
                realm.delete(thawedRecord)
            }
            realm.add(newRecord)

            event.items.append(newRecord)
        }

        dismiss()

        // 发起 App Store 评论请求
        AppManager.shared.requestReview(delay: 2)
    }
}

#Preview {
    NewRecordView(event: EventObject(emoji: "👌", name: "Programing", hex: HexObject(hex: "#757573")), startAt: .init(), endAt: .init())
}
