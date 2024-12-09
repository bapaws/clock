//
//  File.swift
//
//
//  Created by 张敏超 on 2024/6/5.
//

import ClockShare
import Foundation
import IceCream
import IdentifiedCollections
import OrderedCollections
import RealmSwift
import SwiftUIX

public actor AppRealm {
    public static let shared = AppRealm()

    private var syncEngine: SyncEngine?

    // MARK: Realm

    public let schemaVersion: UInt64 = 15
    public let fileName = "default"

    private var _realm: Realm?
    public var realm: Realm {
        get async {
            if let _realm {
                /// 当未注册本地通知时，注册本地通知
                if let syncEngine, !syncEngine.isLocalDatabaseListened {
                    syncEngine.registerLocalDatabase()
                }
                return _realm
            }
            do {
                // 老版本数据配置
                let originalConfig = Realm.Configuration(schemaVersion: schemaVersion)
                let fileManager = FileManager.default

                guard let fileURL = Storage.default.groupURL?.appendingPathComponent(fileName) else {
                    Realm.Configuration.defaultConfiguration = originalConfig
                    _realm = try await Realm(configuration: originalConfig, actor: self)
                    return _realm!
                }

                if let originalFileURL = originalConfig.fileURL, fileManager.fileExists(atPath: originalFileURL.path), !fileManager.fileExists(atPath: fileURL.path) {
                    try fileManager.moveItem(at: originalFileURL, to: fileURL)
                }
                debugPrint(fileURL)

                let config = Realm.Configuration(
                    fileURL: fileURL,
                    schemaVersion: schemaVersion
                ) { migration, oldSchemaVersion in
                    if oldSchemaVersion <= 8 {
                        migration.enumerateObjects(ofType: SchemeObject.className()) { _, newObject in
                            newObject?["_id"] = ObjectId.generate()
                        }
                    }
                }
                Realm.Configuration.defaultConfiguration = config
                _realm = try await Realm(configuration: config, actor: self)
            } catch {
                debugPrint(error)
            }

            return _realm!
        }
    }

    public func close() {
        _realm = nil
    }

    // MARK: HEX

    public lazy var hexs: [HexEntity] = []
    private lazy var hexIndex = Storage.default.hexIndex ?? 27 {
        didSet { Storage.default.hexIndex = hexIndex }
    }
}

// MARK: Sync

public extension AppRealm {
    func setupSyncCloud() async {
        let realmConfiguration = await realm.configuration
        syncEngine = SyncEngine(objects: [
            SyncObject(
                realmConfiguration: realmConfiguration,
                type: SchemeObject.self
            ),
            SyncObject(
                realmConfiguration: realmConfiguration,
                type: HexObject.self
            ),
            SyncObject(
                realmConfiguration: realmConfiguration,
                type: RecordObject.self
            ),
            SyncObject(
                realmConfiguration: realmConfiguration,
                type: EventObject.self,
                uListElementType: RecordObject.self
            ),
            SyncObject(
                realmConfiguration: realmConfiguration,
                type: CategoryObject.self,
                uListElementType: EventObject.self
            ),
        ])
    }

    func pushAll() {
        syncEngine?.pushAll()
    }

    func pullAll(completionHandler: ((Error?) -> Void)? = nil) {
        // 手动删除 token，强制 iCloud 重新获取全部数据
        syncEngine?.clearTokens()
        syncEngine?.pull(completionHandler: completionHandler)
    }
}

//// MARK: HEX
//
// extension AppRealm {
//    private func writeHexes() async {
//        let realm = await realm
//
//        let nipponColorsKey = "NipponColors"
//        let userDefaults = UserDefaults.standard
//        if userDefaults.bool(forKey: nipponColorsKey) { return }
//
//        guard let jsonData = nipponColors.data(using: .utf8) else { return }
//        do {
//            let decoder = JSONDecoder()
//            let colors = try decoder.decode([OneColor].self, from: jsonData)
//            let hexs = colors.map { HexObject(hex: $0.hex) }
//            try await realm.asyncWrite {
//                realm.add(hexs)
//            }
//
//            userDefaults.set(true, forKey: nipponColorsKey)
//        } catch {
//            debugPrint(error)
//        }
//    }
//
//    public var nextHex: HexEntity {
//        get async {
//            if hexs.isEmpty {
//                await writeHexes()
//
//                let realm = await realm
//                let entities = realm.objects(HexObject.self)
//                    .map { HexEntity(object: $0) }
//                hexs.append(contentsOf: entities)
//            }
//
//            guard !hexs.isEmpty else { return HexEntity.random }
//
//            let hex = hexs[hexIndex % hexs.count]
//            hexIndex += 1
//            return hex
//        }
//    }
// }
