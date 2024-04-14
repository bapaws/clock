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

    // MARK: Record

    @State var newRecordSelectEvent: EventObject?

    // MARK: Timer

    @Binding var timerSelectEvent: EventObject?

    @State private var selectionType: EventDetailViewSelectionType = .statistics

    @Environment(\.safeAreaInsets) var safeAreaInsets

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
        .background(ui.background)

        // MARK: New Record

        .sheet(item: $selectedRecord) {
            presentNewRecord(for: $0)
        }
        .sheet(item: $newRecordSelectEvent) { event in
            presentNewRecord(event: event)
        }
    }

    var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                number

                // Records
                if event.items.isEmpty {
                    Image("NotFound")
                        .padding(.large)
                        .padding(.top, .large)
                } else {
                    EventRecordsView(event: event, editRecord: $selectedRecord)
                }
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

    func presentNewRecord(for record: RecordObject? = nil, event: EventObject? = nil) -> some View {
        var newRecordView: NewRecordView
        if let record = record {
            newRecordView = NewRecordView(record: record)
        } else {
            newRecordView = NewRecordView(event: event, startAt: newRecordStartAt, endAt: newRecordEndAt)
        }

        let view = newRecordView
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .labelsHidden()
        if #available(iOS 16.4, *) {
            return view
                .presentationCornerRadius(32)
                .presentationContentInteraction(.scrolls)
        } else {
            return view
        }
    }
}

#Preview {
    EventDetailView(
        event: EventObject(name: "iPhone"),
        timerSelectEvent: .constant(EventObject())
    )
}
