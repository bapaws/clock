//
//  TimelineView.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/23.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import RealmSwift
import SwiftDate
import SwiftUI
import SwiftUIX

enum ItemType: Equatable, Identifiable {
    case record(String)
    case timeInterval(Range<Date>)
    case space(String)

    var id: String {
        switch self {
        case .record(let id):
            "Record_\(id)"
        case .timeInterval(let range):
            range.lowerBound.toString(.dateTime(.full)) + range.upperBound.toString(.dateTime(.full))
        case .space(let id):
            "Space_\(id)"
        }
    }
}

@Reducer
struct TimelineFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        let date: Date
        var records: IdentifiedArrayOf<RecordEntity> = []

        var itemTypes = [ItemType]()

        @Presents var newRecord: NewRecordFeature.State?

        var id: Date { date }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case updateRecords([RecordEntity])
        case updateItemTypes([ItemType])

        // RecordsHome 监听
        case onRecordTapped(RecordEntity?)
        case onTimeIntervalTapped(Range<Date>)
        case newRecord(PresentationAction<NewRecordFeature.Action>)

        case onRecordDeleted(RecordEntity)
    }

    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [date = state.date] send in
                    let startOfDay = date.dateAtStartOf(.day)
                    let endOfDay = date.dateAtEndOf(.day)
                    let entities = await AppRealm.shared.getRecords {
                        $0.endAt >= startOfDay &&
                            $0.endAt <= endOfDay
                    }
                    await send(.updateRecords(entities))

                    var itemTypes = [ItemType]()
                    var lowerBound: Date = entities.first?.startAt ?? Date.distantPast
                    for (index, entity) in entities.enumerated() {
                        if lowerBound > entity.endAt {
                            // 最早时间大于记录结束时间，说明有时间间隔
                            itemTypes.append(.timeInterval(entity.endAt ..< lowerBound))

                            // 重新计算间隔，所以设置成记录的开始时间
                            lowerBound = entity.startAt
                        } else if lowerBound > entity.startAt { // 最早时间小于结束时间 & 大于开始时间，说明两条记录有部分重合，没有间隔
                            // 添加分割空间
                            itemTypes.append(.space(entity.id))

                            // 重新计算间隔，所以设置成记录的开始时间
                            lowerBound = entity.startAt
                        } else if index != 0 { // 最早时间小于记录开始时间，说明包含了记录，只需添加分割空间
                            itemTypes.append(.space(entity.id))
                        }

                        itemTypes.append(.record(entity.id))
                    }
                    await send(.updateItemTypes(itemTypes))
                }

            case .updateRecords(let entities):
                state.records.removeAll(keepingCapacity: true)
                state.records.append(contentsOf: entities)
                return .none

            case .updateItemTypes(let types):
                state.itemTypes = types
                return .none

            case .onTimeIntervalTapped(let range):
                state.newRecord = NewRecordFeature.State(startAt: range.lowerBound, endAt: range.upperBound)
                return .none

            case .onRecordDeleted(let entity):
                state.records.removeAll { $0 == entity }
                state.itemTypes.removeAll {
                    if case .record(let id) = $0, id == entity.id {
                        return true
                    }
                    if case .space(let id) = $0, id == entity.id {
                        return true
                    }
                    return false
                }
                return .run { send in
                    await AppRealm.shared.deleteRecord(entity)
                    if let calendarEventIdentifier = entity.calendarEventIdentifier {
                        AppManager.shared.deleteCalendarEvent(for: calendarEventIdentifier)
                    }

                    await send(.onAppear, animation: .default)
                }

            default:
                return .none
            }
        }
        .ifLet(\.$newRecord, action: \.newRecord) {
            NewRecordFeature()
        }
    }
}

struct TimelineView: View {
    @Perception.Bindable var store: StoreOf<TimelineFeature>

    var body: some View {
        WithPerceptionTracking {
            Group {
                if store.records.isEmpty {
                    NotFoundView()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.onRecordTapped(nil))
                        }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(store.itemTypes) { itemType in
                                WithPerceptionTracking {
                                    if case .record(let id) = itemType, let record = store.records[id: id] {
                                        TimelineRecordView(record: record) {
                                            store.send(.onRecordTapped(record))
                                        } onDeleted: {
                                            store.send(.onRecordDeleted(record), animation: .default)
                                        }
                                    } else if case .timeInterval(let range) = itemType {
                                        TimelineTimeIntervalView(range: range)
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                store.send(.onTimeIntervalTapped(range))
                                            }
                                    } else {
                                        TimelineSpaceView()
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(item: $store.scope(state: \.newRecord, action: \.newRecord)) {
                NewRecordView(store: $0)
                    .sheetStyle(detents: [.height(640)])
            }
        }
    }
}

#Preview {
    TimelineView(
        store: .init(initialState: .init(date: .now), reducer: { TimelineFeature() })
    )
}
