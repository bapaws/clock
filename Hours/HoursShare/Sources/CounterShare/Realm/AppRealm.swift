//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import Foundation
import IdentifiedCollections
import OrderedCollections
import RealmSwift
import SwiftUIX

public actor AppRealm {
    public static let shared = AppRealm()

    // MARK: Realm

    public let schemaVersion: UInt64 = 7
    public let fileName = "default"

    private var _realm: Realm?
    public var realm: Realm {
        get async {
            if let _realm { return _realm }
            do {
                // 老版本数据配置
                let originalConfig = Realm.Configuration(schemaVersion: schemaVersion)
                let fileManager = FileManager.default

                guard let fileURL = Storage.default.groupURL?.appendingPathComponent(fileName) else {
                    _realm = try await Realm(configuration: originalConfig, actor: self)
                    return _realm!
                }

                if let originalFileURL = originalConfig.fileURL, fileManager.fileExists(atPath: originalFileURL.path), !fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.moveItem(at: originalFileURL, to: fileURL)
                }

                let config = Realm.Configuration(
                    fileURL: fileURL,
                    schemaVersion: schemaVersion
                )
                Realm.Configuration.defaultConfiguration = config
                _realm = try await Realm(configuration: config, actor: self)
            } catch {
                debugPrint(error)
            }

            return _realm!
        }
    }

    // MARK: HEX

    public lazy var hexs: [HexEntity] = []
    private lazy var hexIndex = Storage.default.hexIndex ?? 27 {
        didSet { Storage.default.hexIndex = hexIndex }
    }
}

// MARK: HEX

extension AppRealm {
    private func writeHexes() async {
        let realm = await realm

        let nipponColorsKey = "NipponColors"
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: nipponColorsKey) { return }

        guard let jsonData = nipponColors.data(using: .utf8) else { return }
        do {
            let decoder = JSONDecoder()
            let colors = try decoder.decode([OneColor].self, from: jsonData)
            let hexs = colors.map { HexObject(hex: $0.hex) }
            try await realm.asyncWrite {
                realm.add(hexs)
            }

            userDefaults.set(true, forKey: nipponColorsKey)
        } catch {
            debugPrint(error)
        }
    }

    public var nextHex: HexEntity {
        get async {
            if hexs.isEmpty {
                await writeHexes()

                let realm = await realm
                let entities = realm.objects(HexObject.self)
                    .map { HexEntity(object: $0) }
                hexs.append(contentsOf: entities)
            }

            guard !hexs.isEmpty else { return HexEntity.random }

            let hex = hexs[hexIndex % hexs.count]
            hexIndex += 1
            return hex
        }
    }
}
