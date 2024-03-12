//
//  EventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/5.
//

import ClockShare
import HoursShare
import Realm
import RealmSwift
import SwiftUI
import SwiftUIX

struct EventsView: View {
    @ObservedSectionedResults(
        EventObject.self,
        sectionBlock: { $0.category!.name },
        sortDescriptors: [SortDescriptor(keyPath: \EventObject.createdAt, ascending: false)],
        configuration: DBManager.default.config
    )
    var sections

    var today: Date { AppManager.shared.today }

    @State var currentDate: Date = .init()

    @State var isInfinity: Bool = false

    @State var category: CategoryObject? = DBManager.default.categorys.first

    @State private var selectEvent: EventObject?
    @State private var newRecordSelectEvent: EventObject?

    @State private var isTimerPresented = false
    @State private var isPomodoroPresented = false

    @State private var newEventSelectCategory: CategoryObject?

    @State private var isNewRecordPresented = false

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(sections, id: \.id) { section in
                    let category = DBManager.default.categorys.first(where: { $0.name == section.key })!
                    LazyVStack(spacing: 16) {
                        HStack {
                            CategoryView(category: category)
                            Spacer()
                            Button(action: {
                                newEventSelectCategory = category
                            }) {
                                Image(systemName: "plus")
                            }
                        }

                        ForEach(section) { event in
                            EventItemView(event: event, playAction: presentTimer)
                                .onTapGesture {
                                    newRecordSelectEvent = event
                                    isNewRecordPresented.toggle()
                                }
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color.secondarySystemBackground)

        // MARK: Timer

        .fullScreenCover(isPresented: $isTimerPresented, onDismiss: {
            selectEvent = nil
        }) {
            TimerView(task: $selectEvent, isPresented: $isTimerPresented)
                .environmentObject(TimerManager.shared)
        }

        // MARK: Pomodoro

        .fullScreenCover(isPresented: $isPomodoroPresented, onDismiss: {
            selectEvent = nil
        }) {
            PomodoroView(task: $selectEvent, isPresented: $isPomodoroPresented)
                .environmentObject(PomodoroManager.shared)
        }

        // MARK: New Record

        .sheet(item: $newRecordSelectEvent) { event in
            let date = DBManager.default.getRecordEndAt(for: today)
            let startAt = date ?? today.dateBySet(hour: 9, min: 0, secs: 0)!
            let view = NewRecordView(event: event, startAt: startAt, endAt: Date.now, isPresented: $isNewRecordPresented)
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Toggle(isOn: $isInfinity) {
                    Text("")
                }
                .toggleStyle(
                    SymbolToggleStyle(onSystemName: "infinity.circle", onFillColor: .mint, offSystemName: "timer", offFillColor: .mint)
                )
            }
        }
    }

    private func presentTimer(event: EventObject) {
        selectEvent = event
        isTimerPresented = isInfinity
        isPomodoroPresented = !isInfinity
    }
}

#Preview {
    EventsView()
}
