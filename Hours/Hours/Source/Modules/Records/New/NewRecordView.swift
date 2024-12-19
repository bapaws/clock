//
//  NewRecordView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/11.
//

import ComposableArchitecture
import HoursShare
import PopupView
import Pow
import SwiftUI
import SwiftUIX
import UIKit

struct NewRecordView: View {
    @Perception.Bindable var store: StoreOf<NewRecordFeature>

    @State private var isStartTimePresented = false
    @State private var isEndTimePresented = false

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(store.record == nil ? L10n.newRecord : L10n.editRecord)
                            .font(.title)
                            .foregroundStyle(ui.primary)
                        Spacer()
                        if let category = store.event?.category {
                            CategoryView(category: category)
                        }
                    }
                    .padding()

                    NewItemView(title: L10n.event) {
                        WithPerceptionTracking {
                            if let event = store.event {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(event.primary)
                                    .width(4)
                                Text(event.name)
                            } else {
                                Text(L10n.pleaseSelect)
                                    .foregroundStyle(Color.placeholderText)
                            }
                        }
                    }
                    .onTapGesture {
                        store.send(.selectEventTapped)
                    }
                    .changeEffect(.shake(rate: .fast), value: store.createAttempts)

                    NewItemView(title: L10n.startTime) {
                        WithPerceptionTracking {
                            Text(store.startAt.to(format: "MMMddHH:mm"))
                                .monospacedDigit()
                        }
                    }
                    .onTapGesture {
                        isStartTimePresented = true
                    }

                    NewItemView(title: L10n.endTime) {
                        WithPerceptionTracking {
                            Text(store.endAt.to(format: "MMMddHH:mm"))
                                .monospacedDigit()
                        }
                    }
                    .onTapGesture {
                        isEndTimePresented = true
                    }

                    TextField(L10n.notes, text: $store.notes, axis: .vertical)
                        .lineLimit(5 ... 10)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(ui.secondaryBackground))

                    HStack(spacing: 16) {
                        Button {
                            store.send(.cancel)
                        } label: {
                            Text(L10n.cancel)
                                .padding(.vertical, .small)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(ui.primary)
                        .cornerRadius(16)

                        Button {
                            store.send(.save)
                        } label: {
                            Text(L10n.save)
                                .padding(.vertical, .small)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(ui.primary)
                        .foregroundStyle(Color.white)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(16)
                        .disabled(store.event == nil || store.isLoading)
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
                .padding(.vertical, .large)
            }
            .scrollIndicators(.hidden)
            .background(ui.background)

            // MARK: Start Time

            .sheet(isPresented: $isStartTimePresented) {
                WithPerceptionTracking {
                    NewRecordTimeView(title: "Start Time", dateTime: $store.startAt)
                        .sheetStyle()
                }
            }
            .onChange(of: store.startAt) {
                store.send(.onStartAtChanged($0))
            }

            // MARK: End Time

            .sheet(isPresented: $isEndTimePresented) { [startAt = store.startAt] in
                WithPerceptionTracking {
                    NewRecordEndAtPickerView(startAt: startAt, dateTime: $store.endAt)
                        .sheetStyle()
                }
            }

            // MARK: Event

            .sheet(item: $store.scope(state: \.selectEvent, action: \.selectEvent)) { store in
                SelectEventView(store: store)
                    .sheetStyle()
            }
        }
    }
}

#Preview {
    NewRecordView(
        store: StoreOf<NewRecordFeature>(
            initialState: .init(event: .random(), startAt: .init(), endAt: .init()),
            reducer: { NewRecordFeature() }
        )
    )
}
