//
//  RecordsHomeView.swift
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

struct RecordsHomeView: View {
    @Perception.Bindable var store: StoreOf<RecordsHomeFeature>

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
                    .sheetStyle(detents: [.height(640)])
            }
            .onChange(of: AppManager.shared.today) { newValue in
                currentDate = newValue
            }
        }
    }
}

#Preview {
    RecordsHomeView(
        store: .init(initialState: .init(), reducer: { RecordsHomeFeature() })
    )
}
