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

    var today: Date { app.today }

    @State private var selectEvent: EventObject?
    @State private var newRecordSelectEvent: EventObject?

    @State private var timerSelectEvent: EventObject?
    @State private var isTimerPresented: Bool = false
    @State private var pomodoroSelectEvent: EventObject?
    @State private var isPomodoroPresented: Bool = false

    @State private var newEventSelectCategory: CategoryObject?

    @State private var isNewRecordPresented = false

    var isInfinity: Binding<Bool> {
        Binding(get: {
            app.timingMode == .timer
        }, set: { newValue in
            app.timingMode = newValue ? .timer : .pomodoro
        })
    }

    var body: some View {
        NavigationStack {
            EventsView(menuItems: menuItems, newEventAction: { category in
                newEventSelectCategory = category
            }, playAction: presentTimer, tapAction: { event in
                selectEvent = event
                isNewRecordPresented.toggle()
            })
            .background(UIManager.shared.colors.background)
            .navigationTitle(R.string.localizable.events())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle(isOn: isInfinity) {
                        Text("")
                    }
                    .toggleStyle(
                        SymbolToggleStyle(
                            onSystemName: "infinity.circle",
                            onFillColor: ui.primary,
                            offSystemName: "timer",
                            offFillColor: ui.primary
                        )
                    )
                }
            }
        }

        // MARK: Timer

        .fullScreenCover(isPresented: $isTimerPresented) { [timerSelectEvent] in
            TimerView(event: timerSelectEvent!)
                .environmentObject(TimerManager.shared)
        }

        // MARK: Pomodoro

        .fullScreenCover(isPresented: $isPomodoroPresented) { [pomodoroSelectEvent] in
            PomodoroView(event: pomodoroSelectEvent!)
                .environmentObject(PomodoroManager.shared)
        }

        // MARK: New Record

        .sheet(isPresented: $isNewRecordPresented) { [selectEvent] in
            let date = DBManager.default.getRecordEndAt(for: today)
            let startAt = date ?? today.dateBySet(hour: 9, min: 0, secs: 0)!
            let endAt = Date.now < startAt ? startAt.addingTimeInterval(3600) : Date.now
            let view = NewRecordView(event: selectEvent, startAt: startAt, endAt: endAt, isPresented: $isNewRecordPresented)
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
                selectEvent = event
                isNewRecordPresented = true
            }) {
                Label(R.string.localizable.newRecord(), systemImage: "plus")
            }
            Button(action: {
                timerSelectEvent = event
                isTimerPresented = true
            }) {
                Label(R.string.localizable.startTimer(), systemImage: "infinity.circle")
            }
            Button(action: {
                pomodoroSelectEvent = event
                isPomodoroPresented = true
            }) {
                Label(R.string.localizable.startPomodoro(), systemImage: "timer")
            }
            Button(role: .destructive, action: {
                deleteEvent(event)
            }) {
                Label(R.string.localizable.delete(), systemImage: "trash")
            }
        }
    }

    private func presentTimer(event: EventObject) {
        if app.timingMode == .timer {
            timerSelectEvent = event
            isTimerPresented = true
        } else {
            pomodoroSelectEvent = event
            isPomodoroPresented = true
        }
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
