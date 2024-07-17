//
//  TimingEventsView.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/9.
//

import ClockShare
import ComposableArchitecture
import HoursShare
import SwiftDate
import SwiftUI
import SwiftUIX

@Reducer
struct TimingEventsFeature {
    @ObservableState
    struct State: Equatable {
        var entities: IdentifiedArrayOf<TimingEntity> = []
        @Presents var timer: TimerFeature.State?
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear

        case onTimingEventTapped(TimingEntity)
        case updateTimingEntities(IdentifiedArrayOf<TimingEntity>)

        case stopTimer(TimingEntity)
        case remainingTime(Int)

        case onTimingTapped(TimingEntity)
        case timer(PresentationAction<TimerFeature.Action>)
    }

    enum CancelID { case remainingTime }

    @Dependency(\.date.now) var now
    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let app = AppManager.shared
                    let entities = TimerManager.shared.timingEntities
                    var timingEntities: IdentifiedArrayOf<TimingEntity> = []
                    // 最大的计时时间，用于获取下次刷新的时间
                    var maxMilliseconds = -1
                    #if DEBUG
                    let maximumRecordedMilliseconds = 120 * 1000
                    #else
                    let maximumRecordedMilliseconds = Int(app.maximumRecordedTime) * 1000
                    #endif
                    for entity in entities {
                        let time = entity.time
                        if Int(time.initialDate.distance(to: now) * 1000) > maximumRecordedMilliseconds {
                            // 结束超时的计时
                            await send(.stopTimer(entity))
                        } else {
                            timingEntities.append(entity)
                        }

                        maxMilliseconds = max(maxMilliseconds, time.milliseconds)
                    }

                    await send(.updateTimingEntities(timingEntities), animation: .default)

                    // 超时刷新时间
                    await send(.remainingTime(maximumRecordedMilliseconds - maxMilliseconds))
                }

            case .updateTimingEntities(let entities):
                state.entities = entities
                return .none

            case .stopTimer(let entity):
                return .run { send in
                    // 停止计时
                    TimerManager.shared.stop(of: entity)

                    let app = AppManager.shared
                    var time = entity.time
                    // 这里先调用 ++，相当于计时
                    time++

                    guard time.milliseconds > Int(app.minimumRecordedTime * 1000) else {
                        await send(.onAppear)
                        return
                    }
                    guard let event = await AppRealm.shared.getEvent(by: entity.id) else {
                        await send(.onAppear)
                        return
                    }

                    let milliseconds = min(time.milliseconds, Int(app.maximumRecordedTime * 1000))
                    var newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
                    // 同步到日历应用
                    let eventIdendtifier = app.syncToCalendar(for: event, record: newRecord)
                    newRecord.calendarEventIdentifier = eventIdendtifier
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)

                    await send(.onAppear)
                }

            case .remainingTime(let milliseconds):
                if milliseconds <= 0 { return .none }
                return .run { send in
                    try await Task.sleep(for: .milliseconds(milliseconds))
                    await send(.onAppear)
                }
                .cancellable(id: CancelID.remainingTime, cancelInFlight: true)

            default:
                return .none
            }
        }
        .ifLet(\.$timer, action: \.timer) {
            TimerFeature()
        }
    }
}

struct TimingEventsView: View {
    @Perception.Bindable var store: StoreOf<TimingEventsFeature>

    var body: some View {
        WithPerceptionTracking {
            if !store.entities.isEmpty {
                Section {
                    // 这里需要单独设置 id，因为可能会和正常的重复，导致 view 重用
                    ForEach(store.entities, id: { $0.id + "Timing" }) { event in
                        HStack(spacing: 16) {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(event.primary)
                                    .frame(width: 4)
                                if let emoji = event.emoji {
                                    Text(emoji)
                                        .padding(.small)
                                }
                                Text(event.name)
                                    .font(.body, weight: .regular)
                            }
                            .padding(.leading)
                            .padding(.vertical)

                            Spacer()

                            Text(timerInterval: event.timerInterval, countsDown: false)
                                .contentTransition(.numericText(countsDown: false))
                                .font(.system(.body, design: .rounded, weight: .bold))
                                .monospacedDigit()
                                .foregroundStyle(event.primary)

                            Button {
                                store.send(.stopTimer(event))
                            } label: {
                                Image(systemName: "stop.fill")
                                    .font(.system(.callout, design: .rounded))
                                    .foregroundStyle(event.primary)
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(event.primaryContainer)
                                    }
                            }
                        }
                        .padding(.trailing)
                        .frame(height: cellHeight)
                        .background(ui.secondaryBackground)
                        .cornerRadius(16)
                        .onTapGesture {
                            store.send(.onTimingTapped(event))
                        }
                    }
                    .frame(height: cellHeight)
                    .padding(.horizontal)

                    ui.background.height(12)
                } header: {
                    HStack {
                        Text(L10n.tracking("\(store.entities.count)"))
                        Spacer()
                    }
                    .font(.footnote)
                    .padding(horizontal: .regular, vertical: .extraSmall)
                    .background(ui.background)
                }
            }
        }
    }
}

#Preview {
    TimingEventsView(
        store: .init(initialState: .init(), reducer: { TimingEventsFeature() })
    )
}
