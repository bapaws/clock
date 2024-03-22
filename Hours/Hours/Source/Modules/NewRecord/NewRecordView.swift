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

struct NewRecordEnterView: View {
    let title: String
    let placeholder: String
    let text: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body, weight: .bold)
            Spacer()

            Text(text)
                .font(.body, weight: .bold)
        }
        .multilineTextAlignment(.trailing)
        .padding()
        .padding(.horizontal, .small)
        .background(.tertiarySystemBackground)
        .cornerRadius(16)
    }
}

struct NewRecordView: View {
    @State var event: EventObject?
    @State var startAt: Date
    @State var endAt: Date
    @Binding var isPresented: Bool

    @State var isEventPresented = false
    @State var isStartTimePresented = false
    @State var isEndTimePresented = false

    @State var createAttempts = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(R.string.localizable.newRecord())
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
                Text(startAt.toString(.time(.short)))
            }
            .onTapGesture {
                isStartTimePresented = true
            }

            NewItemView(title: R.string.localizable.endTime()) {
                Text(endAt.toString(.time(.short)))
            }
            .onTapGesture {
                isEndTimePresented = true
            }

            HStack(spacing: 16) {
                Button(action: {
                    isPresented = false
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

        let record = RecordObject(creationMode: .enter, startAt: startAt, endAt: endAt)
        try? realm.write {
            realm.add(record)

            event.items.append(record)
        }

        isPresented = false
    }
}

#Preview {
    NewRecordView(event: EventObject(emoji: "👌", name: "Programing", hex: HexObject(hex: "#757573")), startAt: .init(), endAt: .init(), isPresented: .constant(false))
}
