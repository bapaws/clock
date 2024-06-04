//
//  StatisticsDailyRealm.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/1.
//

import Foundation
import HoursShare
import RealmSwift

actor StatisticsDailyRealm {
    var realm: Realm!
    init() async throws {
        realm = try await Realm(actor: self)
    }

    /// 包含结束时间在 startAt 和 endAt 的所有记录
    func getRecordEntitiesEndAt(from: Date, to: Date) -> [RecordEntity] {
        realm.objects(RecordObject.self)
            .where { $0.endAt >= from && $0.endAt <= to }
            .sorted(by: \.startAt, ascending: true)
            .map { RecordEntity(object: $0) }
    }
}
