//
//  RecordsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/3/10.
//

import ClockShare
import ComposableArchitecture
import Dependencies
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIPager
import SwiftUIX

struct RecordsView: View {
    @Perception.Bindable var store: StoreOf<RecordsFeature>

    @State var currentDate: Date = AppManager.shared.today

    @EnvironmentObject var app: AppManager
    @EnvironmentObject var ui: UIManager

    var today: Date { app.today }
    var initialDate: Date { app.initialDate }

    @State private var isDatePickerPresented: Bool = false

    @State private var selectedRecord: RecordEntity?
    @State private var isNewRecordPresented: Bool = false

    var pageIndex: Binding<Int> {
        Binding<Int>(get: {
            currentDate.difference(in: .day, from: initialDate)!
        }, set: { newValue in
            currentDate = initialDate.dateByAdding(newValue, .day).date
        })
    }

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                CalendarHeaderPageView(store: store.scope(state: \.calendar, action: \.calendar)) {
                    store.send(.onNewRecordTapped(nil))
                }

                TimelinePageView(store: store.scope(state: \.timeline, action: \.timeline)) {
                    store.send(.onNewRecordTapped($0))
                }
            }
            .onChange(of: store.home.date) { newValue in
                store.send(.timeline(.onRecordLoaded(newValue)))
            }
            .background(ui.background)
            .sheet(item: $store.scope(state: \.newRecord, action: \.newRecord)) {
                NewRecordView(store: $0)
                    .sheetStyle()
            }
            .onChange(of: AppManager.shared.today) { newValue in
                currentDate = newValue
            }
        }
    }

    // MARK: New Record

    var newRecordStartAt: Date {
        let date = DBManager.default.getRecordEndAt(for: currentDate)
        return date ?? currentDate.dateBySet(hour: 9, min: 0, secs: 0)!
    }

    var newRecordEndAt: Date {
        let startAt = newRecordStartAt
        var endAt = startAt.addingTimeInterval(3600)
        if currentDate.compare(.isSameDay(today)) {
            endAt = Date.now < startAt ? startAt.addingTimeInterval(3600) : Date.now
        }
        return endAt
    }

    func presentNewRecord(for record: RecordEntity? = nil) -> some View {
        var store: StoreOf<NewRecordFeature>
        if let record {
            store = StoreOf<NewRecordFeature>(
                initialState: .init(record: record),
                reducer: { NewRecordFeature() }
            )

        } else {
            store = StoreOf<NewRecordFeature>(
                initialState: .init(startAt: newRecordStartAt, endAt: newRecordEndAt),
                reducer: { NewRecordFeature() }
            )
        }

        return NewRecordView(store: store).sheetStyle()
    }
}

#Preview {
    RecordsView(
        store: .init(initialState: .init(), reducer: { RecordsFeature() })
    )
}
