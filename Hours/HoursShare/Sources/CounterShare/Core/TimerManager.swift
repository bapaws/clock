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

    public let timerStop = Notification.Name("TimerStop")

    // MARK: Event

    public func start(of event: EventObject) {
        super.start()

        Storage.default.currentTimerTime = time
        Storage.default.currentTimerEventID = event._id.stringValue

        if #available(iOS 16.1, *) {
            TimerActivity.shared.start(attributes: TimerActivityAttributes(event: event), time: time)
        }
    }

    override public func pause() {
        super.pause()

        Storage.default.currentTimerTime = time
    }

    override public func resume() {
        super.resume()

        Storage.default.currentTimerTime = time
    }

    override public func stop() {
        super.stop()

        Storage.default.currentTimerTime = nil
        Storage.default.currentTimerEventID = nil

        if #available(iOS 16.1, *) {
            TimerActivity.shared.stop()
        }
    }
}
