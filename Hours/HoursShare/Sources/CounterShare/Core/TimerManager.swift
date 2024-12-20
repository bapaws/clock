//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/23.
//

import ActivityKit
import ClockShare
import Foundation
import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
public struct TimingEntityActivityAttributes: ActivityAttributes {
    public typealias ContentState = [TimingEntity]

    public static var preview: TimingEntityActivityAttributes {
        TimingEntityActivityAttributes()
    }
}

public class TimerManager: ObservableObject {
    public static let shared = TimerManager()

    @AppStorage(Storage.Key.hourStyle, store: Storage.default.store)
    public var hourStyle: DigitStyle = .none

    public private(set) var timingEntities: [TimingEntity] {
        didSet {
            Storage.default.currentTimingEntities = timingEntities
        }
    }

    public let timerStart = Notification.Name("TimerStart")
    public let timerStop = Notification.Name("TimerStop")

    init() {
        if let timingEntities = Storage.default.currentTimingEntities {
            self.timingEntities = timingEntities

            // 更新小组件
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Quick.large)
            // 重启后，重新启动实时活动
            if #available(iOS 16.1, *) {
                startActivity()
            }
        } else {
            self.timingEntities = []
        }
    }

    // MARK: Event

    public func start(of entity: TimingEntity) {
        timingEntities.removeAll { $0.id == entity.id }
        timingEntities.append(entity)

        WidgetCenter.shared.reloadTimelines(ofKind: WidgetsKind.Quick.large)

        if #available(iOS 16.1, *) {
            startActivity()
        }
    }

    @available(iOS 16.1, *)
    private func startActivity() {
        // Copy timingEntities
        let timingEntities = timingEntities
        if timingEntities.isEmpty { return }

        Task {
            let activities = Activity<TimingEntityActivityAttributes>.activities
            if activities.isEmpty {
                let attributes = TimingEntityActivityAttributes()
                do {
                    if #available(iOS 16.2, *) {
                        let content = ActivityContent(state: timingEntities, staleDate: nil)
                        _ = try Activity.request(attributes: attributes, content: content, pushType: .token)
                    } else {
                        _ = try Activity.request(attributes: attributes, contentState: timingEntities, pushType: .token)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                for activitiy in activities {
                    if #available(iOS 16.2, *) {
                        let content = ActivityContent(state: timingEntities, staleDate: nil)
                        await activitiy.update(content)
                    } else {
                        await activitiy.update(using: timingEntities)
                    }
                }
            }
        }
    }

    public func stop(of entity: TimingEntity, reloadTimelines: Bool = true) {
        timingEntities.removeAll { $0.id == entity.id }

        if reloadTimelines {
            WidgetCenter.shared.reloadAllTimelines()
        }

        if #available(iOS 16.1, *) {
            // Copy timingEntities
            let timingEntities = timingEntities
            Task {
                let activities = Activity<TimingEntityActivityAttributes>.activities
                if timingEntities.isEmpty {
                    for activitiy in activities {
                        await activitiy.end(using: nil, dismissalPolicy: .immediate)
                    }
                } else {
                    for activitiy in activities {
                        if #available(iOS 16.2, *) {
                            let content = ActivityContent(state: timingEntities, staleDate: nil)
                            await activitiy.update(content)
                        } else {
                            await activitiy.update(using: timingEntities)
                        }
                    }
                }
            }
        }
    }
}
