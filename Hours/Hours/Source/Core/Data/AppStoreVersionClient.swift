//
//  AppStoreVersionClient.swift
//  Hours
//
//  Created by 张敏超 on 2024/8/15.
//

import ComposableArchitecture
import Foundation

struct AppStoreVersionClient {
    var fetch: () async throws -> String?
}

extension AppStoreVersionClient: DependencyKey {
    static let liveValue = Self(
        fetch: {
            guard
                let bundleID = Bundle.main.bundleIdentifier,
                let url = URL(string: "https://itunes.apple.com/cn/lookup?bundleId=\(bundleID)")
            else {
                return nil
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let result = try JSONDecoder().decode(ItunesLookupResult.self, from: data)
                return result.results?.first?.version
            } catch {
                debugPrint(error)
                return nil
            }
        }
    )
}

extension DependencyValues {
    var appStoreVersion: AppStoreVersionClient {
        get { self[AppStoreVersionClient.self] }
        set { self[AppStoreVersionClient.self] = newValue }
    }
}
