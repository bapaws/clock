//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/23.
//

import ClockShare
import Foundation

public class TimerManager: ClockShare.TimerBaseManager {
    public static let shared = TimerManager()

    public let timerStart = Notification.Name("TimerStart")
    public let timerStop = Notification.Name("TimerStop")

    // MARK: Event

    public func start(of event: EventEntity) {
        super.start()

        let entity = TimingEntity(event: event, time: time)
        Storage.default.currentTimingEntity = entity

        if #available(iOS 16.1, *) {
            TimerActivity.shared.start(attributes: TimerActivityAttributes(event: event), time: time)
        }
    }

    override public func pause() {
        super.pause()

        guard var entity = Storage.default.currentTimingEntity else { return }
        entity.time = time
        Storage.default.currentTimingEntity = entity
    }

    override public func resume() {
        super.resume()

        guard var entity = Storage.default.currentTimingEntity else { return }
        entity.time = time
        Storage.default.currentTimingEntity = entity
    }

    override public func stop() {
        super.stop()

        Storage.default.currentTimingEntity = nil

        if #available(iOS 16.1, *) {
            TimerActivity.shared.stop()
        }
    }
}
