//
//  EventDetailFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/16.
//

import Collections
import ComposableArchitecture
import Foundation
import HoursShare
import RealmSwift

@Reducer
struct EventDetailFeature {
    @ObservableState
    struct State: Equatable {
        var event: EventEntity
        // 当前事件的所有记录：key 为当天的开始时间；value 是当天的所有记录
        var records: OrderedDictionary<Date, [RecordEntity]> = [:]
        var recordCount: Int = 0

        var selectedRecord: RecordEntity?
        var isEditPresented: Bool = false

        @Presents var newEvent: NewEventFeature.State?
        @Presents var newRecord: NewRecordFeature.State?

        // MARK: Record

        var newRecordSelectEvent: EventEntity?

        // MARK: Timer

        var timerSelectEvent: EventEntity?

        // MARK: Delete

        var isDeletePresented = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case updateRecords(OrderedDictionary<Date, [RecordEntity]>)

        case deleteEvent
        case archiveEvent

        // MARK: New Event

        case newEventTapped
        case newEvent(PresentationAction<NewEventFeature.Action>)

        // MARK: New Record

        case newRecordTapped(RecordEntity?)
        case newRecord(PresentationAction<NewRecordFeature.Action>)
        case updateNewRecordState(NewRecordFeature.State)
        case saveRecordCompleted(RecordEntity)

        case deleteRecord(RecordEntity)
        case deleteRecordCompleted(RecordEntity)
    }

    @Dependency(\.application) private var application
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.date.now) private var now

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [event = state.event] send in
                    let records = await AppRealm.shared.sectionedRecords(event, by: { $0.endAt.dateAt(.startOfDay) })
                    await send(.updateRecords(records), animation: .default)
                }

            case .updateRecords(let entities):
                state.records = entities
                state.recordCount = entities.reduce(0) { $0 + $1.value.count }
                return .none

            case .deleteEvent:
                return .run { [entity = state.event] _ in
                    await AppRealm.shared.deleteEvent(entity)
                    await dismiss()
                }

            case .archiveEvent:
                state.event.archivedAt = .now
                return .run { [entity = state.event] _ in
                    await AppRealm.shared.archiveEvent(entity)
                }

            case .newEventTapped:
                state.newEvent = .init(event: state.event)
                return .none

            case .newRecordTapped(let entity):
                return .run { [event = state.event] send in
                    if let entity {
                        let state = NewRecordFeature.State(record: entity)
                        await send(.updateNewRecordState(state))
                        return
                    }

                    let startOfDay = now.dateAtStartOf(.day)
                    let endOfDay = now.dateAtEndOf(.day)
                    let records = await AppRealm.shared.getRecords(
                        where: { $0.events._id == event._id && $0.endAt >= startOfDay && $0.endAt <= endOfDay }
                    )

                    let record = records.first

                    let startAt = record?.endAt ?? now.addingTimeInterval(-3600)
                    let endAt = startAt.addingTimeInterval(3600)
                    let state = NewRecordFeature.State(event: event, startAt: startAt, endAt: endAt)
                    await send(.updateNewRecordState(state))
                }

            case .updateNewRecordState(let newRecordState):
                state.newRecord = newRecordState
                return .none

            case .newRecord(.presented(.saveCompleted)):
                return .run { send in
                    await send(.onAppear)
                }

            case .deleteRecord(let entity):
                return .run { send in
                    await AppRealm.shared.deleteRecord(entity)
                    await send(.deleteRecordCompleted(entity), animation: .default)
                }

            case .deleteRecordCompleted(let entity):
                state.records[entity.endAt.dateAt(.startOfDay)]?.removeAll { $0.id == entity.id }
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$newEvent, action: \.newEvent) {
            NewEventFeature()
        }
        .ifLet(\.$newRecord, action: \.newRecord) {
            NewRecordFeature()
        }
    }
}
