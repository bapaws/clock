//
//  NewRecordFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import ComposableArchitecture
import Foundation
import HoursShare

@Reducer
struct NewRecordFeature {
    @ObservableState
    struct State: Equatable {
        var record: RecordEntity?

        var event: EventEntity?
        var startAt: Date
        var endAt: Date

        var notes: String = ""

        @Presents var selectEvent: SelectEventFeature.State?

        var isLoading = false
        var createAttempts = 0

        init(event: EventEntity? = nil, startAt: Date, endAt: Date) {
            self.event = event
            self.startAt = startAt
            self.endAt = endAt
        }

        init(record: RecordEntity) {
            self.record = record

            self.event = record.event
            self.startAt = record.startAt
            self.endAt = record.endAt
            self.notes = record.notes ?? ""
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case onStartAtChanged(Date)

        case selectEvent(PresentationAction<SelectEventFeature.Action>)
        case selectEventTapped

        case cancel
        case save
        case saveCompleted(RecordEntity)
    }

    @Dependency(\.isPresented) var isPresented
    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onStartAtChanged(let newValue):
                if state.endAt < newValue {
                    state.endAt = newValue.addingTimeInterval(3600)
                }
                return .none

            case .selectEvent(let action):
                if case .dismiss = action {
                    state.event = state.selectEvent?.selectedEvent
                }
                return .none

            case .selectEventTapped:
                state.selectEvent = SelectEventFeature.State(selectedEvent: state.record?.event)
                return .none

            case .cancel:
                return .run { _ in await dismiss() }

            case .save:
                guard let event = state.selectEvent?.selectedEvent ?? state.event else {
                    state.createAttempts += 1
                    return .none
                }
                state.isLoading = true
                return .run { [state] send in
                    var newRecord = RecordEntity(creationMode: state.record?.creationMode ?? .enter, startAt: state.startAt, endAt: state.endAt)
                    newRecord.notes = state.notes
                    newRecord.event = event
                    if let record = state.record {
                        // 在刷新日历前先赋值旧 id，可以在同步时用于删除日历上的记录
                        newRecord.calendarEventIdentifier = record.calendarEventIdentifier
                        // 重新设置日历记录的 id
                        newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                        await AppRealm.shared.deleteRecord(record)
                    } else {
                        newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    }
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)

                    await send(.saveCompleted(newRecord))
                }

            case .saveCompleted(_):
                return .run { _ in
                    if isPresented {
                        await dismiss()
                    }

                    // 发起 App Store 评论请求
                    AppManager.shared.requestReview()
                }

            default:
                return .none
            }
        }
        .ifLet(\.$selectEvent, action: \.selectEvent) {
            SelectEventFeature()
        }
    }
}
