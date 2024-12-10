//
//  TimerFeature.swift
//  Hours
//
//  Created by 张敏超 on 2024/7/9.
//

import ClockShare
import ComposableArchitecture
import Foundation
import HoursShare
import UIKit

@Reducer
struct TimerFeature {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id: String { entity.id }

        var entity: TimingEntity

        var isStop: Bool = false

        init(event: EventEntity) {
            self.entity = TimingEntity(event: event)
        }

        init(entity: TimingEntity) {
            self.entity = entity
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)

        case startTimer
        case stopTimer
        case timerTick

        case onStopped
        case onDismissed

        case feedback

        case minimize
    }

    enum CancelID { case startTimer }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .startTimer:
                return .run { [isStop = state.isStop, entity = state.entity] send in
                    TimerManager.shared.start(of: entity)
                    while !isStop {
                        try await Task.sleep(for: .milliseconds(500))
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.startTimer, cancelInFlight: true)

            case .stopTimer:
                state.isStop = true
                return .cancel(id: CancelID.startTimer)

            case .timerTick:
                state.entity.time++
                return .none

            case .onStopped:
                return .run { [entity = state.entity] send in
                    await send(.feedback)
                    await send(.stopTimer)

                    // 停止计时
                    TimerManager.shared.stop(of: entity)

                    let app = AppManager.shared
                    var time = entity.time
                    // 这里先调用 ++，相当于计时
                    time++

                    guard time.milliseconds > Int(app.minimumRecordedTime * 1000) else { return }
                    guard let event = await AppRealm.shared.getEvent(by: entity.id) else { return }

                    let milliseconds = app.limitMaximumDuration ? min(time.milliseconds, Int(app.maximumRecordedTime * 1000)) : time.milliseconds
                    var newRecord = RecordEntity(creationMode: .timer, startAt: time.initialDate, milliseconds: milliseconds, endAt: time.date)
                    // 同步到日历应用
                    let eventIdendtifier = await app.syncToCalendar(for: event, record: newRecord)
                    newRecord.calendarEventIdentifier = eventIdendtifier
                    await AppRealm.shared.writeRecord(newRecord, addTo: event)

                    // 发起 App Store 评论请求
                    AppManager.shared.requestReview(delay: 2)

                    await send(.onDismissed)
                }

            case .minimize:
                return .run { _ in await dismiss() }

            case .onDismissed:
                return .run { _ in await dismiss() }

            case .feedback:
                return .run { _ in
                    let impactMed = await UIImpactFeedbackGenerator(style: .medium)
                    await impactMed.impactOccurred()
                }

            default:
                return .none
            }
        }
    }
}
