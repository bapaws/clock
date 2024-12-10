//
//  AppManager.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/7.
//

import Foundation
import HoursShare

public class AppManager: HoursShare.AppManager {
    public static let shared = AppManager()

    override private init() {
        super.init()

        requestCalendarAccess()
    }
}

// MARK: - TimingEntity

public extension TimingEntity {
    var timerInterval: ClosedRange<Date> {
        let app = AppManager.shared
        let timeInterval = app.limitMaximumDuration ? app.maximumRecordedTime : 3 * 24 * 3600
        return time.initialDate ... date.addingTimeInterval(timeInterval)
    }
}
