//
//  NewRecordView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/11.
//

import HoursShare
import PopupView
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

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Create Record")
                    .font(.title)
                    .foregroundStyle(Color.mint)
                Spacer()
                if let category = event?.category {
                    CategoryView(category: category)
                }
            }
            .padding()

            NewItemView(title: "Event") {
                if let event = event {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(event.color)
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

            NewItemView(title: "Start Time") {
                Text(startAt.toString(.time(.short)))
            }
            .onTapGesture {
                isStartTimePresented = true
            }

            NewItemView(title: "End Time") {
                Text(endAt.toString(.time(.short)))
            }
            .onTapGesture {
                isEndTimePresented = true
            }

            HStack(spacing: 16) {
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Cancel")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.bordered)
                .foregroundStyle(Color.mint)
                .cornerRadius(16)

                Button(action: newRecord, label: {
                    Text("Save")
                        .padding(.vertical, .small)
                        .frame(maxWidth: .infinity)
                })
                .tint(Color.mint)
                .foregroundStyle(Color.white)
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .padding(.vertical, .extraLarge)
        .background(Color.secondarySystemBackground)

        // MARK: Start Time

        .sheet(isPresented: $isStartTimePresented, content: {
            if #available(iOS 16.4, *) {
                NewRecordTimeView(title: "Start Time", dateTime: $startAt, isPresented: $isStartTimePresented)
                    .presentationCornerRadius(32)
            } else {
                NewRecordTimeView(title: "Start Time", dateTime: $startAt, isPresented: $isStartTimePresented)
            }
        })

        // MARK: End Time

        .sheet(isPresented: $isEndTimePresented, content: {
            if #available(iOS 16.4, *) {
                NewRecordTimeView(title: "End Time", dateTime: $endAt, isPresented: $isEndTimePresented)
                    .presentationCornerRadius(32)
            } else {
                NewRecordTimeView(title: "End Time", dateTime: $endAt, isPresented: $isEndTimePresented)
            }
        })

        // MARK: Event

        .sheet(isPresented: $isEventPresented, content: {
            let view = EventsView()
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
        guard let realm = event?.realm else { return }

        let record = RecordObject(creationMode: .enter, startAt: startAt, endAt: endAt)
        try? realm.write {
            event?.items.append(record)
        }

        isPresented = false
        event = nil
    }
}

#Preview {
    NewRecordView(startAt: .init(), endAt: .init(), isPresented: .constant(false))
}
