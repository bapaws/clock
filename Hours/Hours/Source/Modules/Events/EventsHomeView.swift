//
//  EventsHomeView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/12.
//

import ClockShare
import HoursShare
import RealmSwift
import SwiftUI

struct EventsHomeView: View {
    @EnvironmentObject var app: AppManager

    @State private var showTabBar = true

    // MARK: Event

    @State private var newEventSelectCategory: CategoryObject?

    // MARK: Record

    @State private var newRecordSelectEvent: EventObject?

    // MARK: Timer

    @State private var timerSelectEvent: EventObject?

    // MARK: Detail

    @State private var detailSelectEvent: EventObject? {
        didSet {
            withAnimation {
                showTabBar = detailSelectEvent == nil
            }
        }
    }

    var isDetailPresented: Binding<Bool> {
        Binding<Bool>(
            get: { detailSelectEvent != nil },
            set: { _ in

                detailSelectEvent = nil
            }
        )
    }

    var body: some View {
        EventsView(menuItems: menuItems, newEventAction: { category in
            newEventSelectCategory = category
        }, playAction: presentTimer, tapAction: { event in
            detailSelectEvent = event
        })
        .background(UIManager.shared.colors.background)
        .navigationTitle(R.string.localizable.events())
        .navigationDestination(isPresented: isDetailPresented) { [detailSelectEvent] in
            if let event = detailSelectEvent {
                EventDetailView(
                    event: event,
                    timerSelectEvent: $timerSelectEvent
                )
            }
        }

        // MARK: Timer

        .fullScreenCover(item: $timerSelectEvent) { event in
            TimerView(event: event)
                .environmentObject(TimerManager.shared)
        }

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

        // MARK: New Event

        .sheet(item: $newEventSelectCategory) { _ in
            let view = NewEventView(category: $newEventSelectCategory)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            if #available(iOS 16.4, *) {
                view
                    .presentationCornerRadius(32)
                    .presentationContentInteraction(.scrolls)
            } else {
                view
            }
        }
    }

    @ViewBuilder func menuItems(for event: EventObject) -> some View {
        Group {
            Button(action: {
                newRecordSelectEvent = event
            }) {
                Label(R.string.localizable.newRecord(), systemImage: "plus")
            }
            Button(action: {
                timerSelectEvent = event
            }) {
                Label(R.string.localizable.startTimer(), systemImage: "infinity.circle")
            }
            Divider()
            if !event.isSystem {
                Button(role: .destructive, action: {
                    deleteEvent(event)
                }) {
                    Label(R.string.localizable.delete(), systemImage: "trash")
                }
            }
        }
    }

    private func presentTimer(event: EventObject) {
        timerSelectEvent = event
    }

    private func deleteEvent(_ event: EventObject) {
        guard let event = event.thaw(), let realm = event.realm?.thaw() else { return }

        try? realm.write {
            realm.delete(event)
        }
    }
}

#Preview {
    EventsHomeView()
}
