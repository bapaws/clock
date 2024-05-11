//
//  EventDetailView.swift
//  Hours
//
//  Created by 张敏超 on 2024/4/3.
//

import ClockShare
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
    @ObservedRealmObject var event: EventObject

    @State var selectedRecord: RecordObject?

    @State var isEditPresented: Bool = false

    // MARK: Record

    @State var newRecordSelectEvent: EventObject?

    // MARK: Timer

    @Binding var timerSelectEvent: EventObject?

    // MARK: Delete

    @State private var isDeletePresented = false

    @State private var selectionType: EventDetailViewSelectionType = .statistics

    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            scrollView

            header
                .padding(.horizontal)
                .padding(.vertical, .small)
                .background(ui.background)

            ui.background.height(safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(event.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(R.string.localizable.edit(), systemImage: "pencil", role: nil) {
                        isEditPresented = true
                    }
                    Button(event.archivedAt == nil ? R.string.localizable.archive() : R.string.localizable.unarchive(), systemImage: event.archivedAt == nil ? "archivebox" : "archivebox.fill", role: nil, action: archiveEvent)
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

        // MARK: New Record

        .sheet(item: $selectedRecord) {
            NewRecordView(record: $0)
                .sheetStyle()
        }
        .sheet(item: $newRecordSelectEvent) { event in
            NewRecordView(event: event, startAt: newRecordStartAt, endAt: newRecordEndAt)
                .sheetStyle()
        }

        // MARK: Event
        .sheet(isPresented: $isEditPresented) {
            NewEventView(event: event)
                .sheetStyle()
        }
        .alert(R.string.localizable.warning(), isPresented: $isDeletePresented, actions: {
            Button(R.string.localizable.cancel(), role: .cancel) {}
            Button(R.string.localizable.delete(), role: .destructive, action: deleteEvent)
        }, message: {
            Text(R.string.localizable.deleteEventWarning(event.name, event.name))
        })
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                number

                // Records
                EventRecordsView(event: event, editRecord: $selectedRecord)
                    .emptyStyle(isEmpty: event.items.isEmpty)
            }
            .padding()
        }
    }

    @ViewBuilder var header: some View {
        HStack(spacing: 16) {
            Button(action: {
                newRecordSelectEvent = event
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text(R.string.localizable.newRecord())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 39, maxHeight: 39)
            }
            .tintColor(ui.primary)
            .buttonStyle(BorderedButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 54, maxHeight: 54)

            Button(action: { timerSelectEvent = event }) {
                Image(systemName: "play.fill")
                    .font(.system(.callout, design: .rounded))
                    .foregroundStyle(event.primary)
                    .frame(width: 54, height: 54)
                    .background(event.primaryContainer)
                    .cornerRadius(16)
            }
            .frame(width: 54, height: 54)
        }
    }

    @ViewBuilder var number: some View {
        HStack(spacing: 16) {
            StatisticsNumberView(imageName: "list.clipboard", title: R.string.localizable.records(), subtitle: R.string.localizable.total(), fillColor: ui.primary) {
                Text("\(event.items.count)")
                    .font(.title, weight: .bold)
                    .foregroundStyle(Color.label)
            }

            StatisticsNumberView(imageName: "hourglass", title: R.string.localizable.timeInvest(), subtitle: R.string.localizable.total(), fillColor: ui.primary) {
                StatisticsTimeView(time: event.time)
            }
        }
    }

    // MARK: New Record

    var newRecordStartAt: Date {
        let date = DBManager.default.getRecordEndAt(for: today)
        return date ?? today.dateBySet(hour: 9, min: 0, secs: 0)!
    }

    var newRecordEndAt: Date {
        return newRecordStartAt.addingTimeInterval(3600)
    }

    private func deleteEvent() {
        guard let event = event.thaw(), let realm = event.realm?.thaw() else { return }

        realm.writeAsync {
            for item in event.items {
                realm.delete(item)
            }
            realm.delete(event)
        }

        dismiss()
    }

    private func archiveEvent() {
        guard let event = event.thaw(), let realm = event.realm?.thaw() else { return }

        realm.writeAsync {
            event.archivedAt = event.archivedAt == nil ? .init() : nil
        }
    }
}

#Preview {
    EventDetailView(
        event: EventObject(name: "iPhone"),
        timerSelectEvent: .constant(EventObject())
    )
}
