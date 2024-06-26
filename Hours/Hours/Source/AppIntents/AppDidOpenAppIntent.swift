//
//  AutoTrackAppIntent.swift
//  Hours
//
//  Created by 张敏超 on 2024/5/9.
//

import AppIntents
import Foundation

struct AppDidOpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "AppDidOpen"

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(Date(), forKey: "AppDidOpen")
        return .result()
    }
}
