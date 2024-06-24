//
//  EventDetailView.swift
//  Hours
//
//  Created by 张敏超 on 2024/4/3.
//

import ClockShare
import ComposableArchitecture
import DeviceActivity
import FamilyControls
import HoursShare
import RealmSwift
import SwiftUI
import SwiftUIX

private enum EventDetailViewSelectionType: Int, Identifiable, CaseIterable {
    case statistics, records
    var id: EventDetailViewSelectionType { self }

    var title: String {
        switch self {
        case .statistics:
            R.string.localizable.statistics()
        case .records:
            R.string.localizable.records()
        }
    }
}

struct EventDetailView: View {
    @Perception.Bindable var store: StoreOf<EventDetailFeature>

    // MARK: Timer

    @Binding var timerSelectEvent: EventEntity?

    // MARK: Delete

    @State private var isDeletePresented = false

    @State private var selectionType: EventDetailViewSelectionType = .statistics

    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                scrollView

                if store.event.archivedAt == nil {
                    footer
                        .padding(.horizontal)
                        .padding(.vertical, .small)
                        .background(ui.background)

                    ui.background.height(safeAreaInsets.bottom)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .navigationTitle(store.event.title)
            .toolbarRole(.editor)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(R.string.localizable.edit(), systemImage: "pencil", role: nil) {
                            store.send(.newEventTapped)
                        }

                        Button(
                            store.event.archivedAt == nil ? R.string.localizable.archive() : R.string.localizable.unarchive(),
                            systemImage: store.event.archivedAt == nil ? "archivebox" : "archivebox.fill",
                            role: nil
                        ) {
                            store.send(.archiveEvent)
                        }
                        .controlSize(.regular)

                        Divider()

                        Button(R.string.localizable.delete(), systemImage: "trash", role: .destructive) {
                            isDeletePresented = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(.leading)
                            .padding(.vertical)
                            .foregroundStyle(ui.label)
                    }
                }
            }
            .background(ui.background)
            .onChange(of: timerSelectEvent) { newValue in
                guard newValue == nil else { return }

                store.send(.onAppear)
            }

            // MARK: New Record

            .sheet(item: $store.scope(state: \.newRecord, action: \.newRecord)) {
                NewRecordView(store: $0)
                    .sheetStyle()
            }

            // MARK: New Event

            .sheet(item: $store.scope(state: \.newEvent, action: \.newEvent)) {
                NewEventView(store: $0)
                    .sheetStyle()
            }

            // MARK: Delete Event

            .alert(R.string.localizable.warning(), isPresented: $isDeletePresented, actions: {
                Button(R.string.localizable.cancel(), role: .cancel) {}
                Button(R.string.localizable.delete(), role: .destructive) {
                    store.send(.deleteEvent)
                }
            }, message: {
                Text(R.string.localizable.deleteEventWarning(store.event.name, store.event.name))
            })
        }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                number

                // Records
                EventRecordsView(records: store.records) {
                    store.send(.newRecordTapped($0))
                } onRecordDeleted: {
                    store.send(.deleteRecord($0))
                }
                .emptyStyle(isEmpty: store.records.isEmpty)
            }
            .padding()
        }
    }

    @ViewBuilder var footer: some View {
        HStack(spacing: 16) {
            Button {
                store.send(.newRecordTapped(nil))
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text(R.string.localizable.newRecord())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 39, maxHeight: 39)
            }
            .tintColor(ui.primary)
            .buttonStyle(BorderedButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 54, maxHeight: 54)

            Button(action: { timerSelectEvent = store.event }) {
                Image(systemName: "play.fill")
                    .font(.system(.callout, design: .rounded))
                    .foregroundStyle(store.event.primary)
                    .frame(width: 54, height: 54)
                    .background(store.event.primaryContainer)
                    .cornerRadius(16)
            }
            .frame(width: 54, height: 54)
        }
    }

    @ViewBuilder var number: some View {
        HStack(spacing: 16) {
            StatisticsNumberView(imageName: "list.clipboard", title: R.string.localizable.records(), subtitle: R.string.localizable.total(), iconBackgound: ui.primary) {
                Text("\(store.recordCount)")
                    .font(.title, weight: .bold)
                    .foregroundStyle(Color.label)
            }

            StatisticsNumberView(imageName: "hourglass", title: R.string.localizable.timeInvest(), subtitle: R.string.localizable.total(), iconBackgound: ui.primary) {
                StatisticsTimeView(time: store.event.time)
            }
        }
    }
}

#Preview {
    EventDetailView(
        store: StoreOf<EventDetailFeature>(initialState: .init(event: .random()), reducer: { EventDetailFeature() }),
        timerSelectEvent: .constant(EventEntity.random())
    )
}
