//
//  QuickStartTimerAppIntent.swift
//  WidgetsExtension
//
//  Created by 张敏超 on 2024/6/6.
//

import AppIntents
import ClockShare
import Foundation
import HoursShare

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct QuickStartTimerAppIntent: AppIntent, LiveActivityStartingIntent {
    static var title: LocalizedStringResource = "QuickTiming"
    static var description = IntentDescription("Quick Timing")

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    static var isDiscoverable: Bool { return false }

    @Parameter(title: "EventID")
    var eventID: String

    init() {}

    init(eventID: String) {
        self.eventID = eventID
    }

    func perform() async throws -> some IntentResult {
        guard let eventEntity = await AppRealm.shared.getEvent(by: eventID) else { return .result() }

        let entity = TimingEntity(event: eventEntity, time: .zero)
        TimerManager.shared.start(of: entity)
        // 从保存 TimingEntity 开始，这里无需发送通知
        // 这个只在点击小组件的事件开始计时时使用，所以发送了通知也无法响应
        // NotificationCenter.default.post(name: TimerManager.shared.timerStart, object: nil)
        return .result()
    }
}

@available(iOSApplicationExtension, unavailable)
extension QuickStartTimerAppIntent: ForegroundContinuableIntent {}
