//
//  UserNotification.swift
//
//
//  Created by 张敏超 on 2024/1/12.
//

import Foundation
import UserNotifications

public class UserNotification {
    public static func request() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in }
    }

    public static func send(title: String, subtitle: String, body: String, timeInterval: TimeInterval) {
        let current = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = .default
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let identifier = "Pomodoro"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        current.add(request)
    }
}
