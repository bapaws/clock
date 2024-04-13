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
import SwiftUI
import SwiftUIX
import RealmSwift

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

    // MARK: Record

    @State var newRecordSelectEvent: EventObject?

    // MARK: Timer

    @Binding var timerSelectEvent: EventObject?

    @State private var selectionType: EventDetailViewSelectionType = .statistics

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 32) {
                    number
                    EventRecordsView(event: event)
                }
                .padding()
            }

            header
                .padding(.horizontal)
                .padding(.vertical, .small)
                .background(ui.background)
        }
        .navigationTitle(event.name)
        .background(ui.background)

        // MARK: New Record

        .sheet(item: $newRecordSelectEvent) { event in
            let date = DBManager.default.getRecordEndAt(for: today)
            let startAt = date ?? today.dateBySet(hour: 9, min: 0, secs: 0)!
            let endAt = Date.now < startAt ? startAt.addingTimeInterval(3600) : Date.now
            let view = NewRecordView(event: event, startAt: startAt, endAt: endAt)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .labelsHidden()
            if #available(iOS 16.4, *) {
                view.presentationCornerRadius(32)
            } else {
                view
            }
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
}

#Preview {
    EventDetailView(
        event: EventObject(name: "iPhone"),
        timerSelectEvent: .constant(EventObject())
    )
}
