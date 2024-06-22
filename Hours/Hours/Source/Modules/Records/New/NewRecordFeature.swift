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

        @Presents var selectEvent: SelectEventFeature.State?

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
        case saveCompletion(RecordEntity)
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
                return .run { [state] send in
                    var newRecord = RecordEntity(creationMode: state.record?.creationMode ?? .enter, startAt: state.startAt, endAt: state.endAt)
                    newRecord.event = event
                    if let record = state.record {
                        newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: record)
                        await AppRealm.shared.deleteRecord(record)
                    } else {
                        newRecord.calendarEventIdentifier = AppManager.shared.syncToCalendar(for: event, record: newRecord)
                    }
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)

                    await send(.saveCompletion(newRecord))
                }

            case .saveCompletion(let entity):
                state.record = entity
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
