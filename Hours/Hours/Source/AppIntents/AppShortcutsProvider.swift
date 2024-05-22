//
//  AppShortcutsProvider.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct HoursAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewRecordAppIntent(),
            phrases: [
                "New Record \(.applicationName)",
                "New Record from \(.applicationName)",
                "Time tracker from \(.applicationName)"
            ],
            shortTitle: "Time Tracker",
            systemImageName: "clock.badge.checkmark.fill"
        )
    }

    static var shortcutTileColor: ShortcutTileColor = .orange
}
