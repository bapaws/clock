//
//  StoreManager.swift
//  Hours
//
//  Created by 张敏超 on 2024/6/3.
//

import Foundation
import ComposableArchitecture

/// 这个类临时用于 TCA 的 Store 保存入口
/// 等 App 完全使用 TCA 之后，这个类的使命就结束了
public class StoreManager {
    static let `default` = StoreManager()

    let store = Store(initialState: Statistics.State()) { Statistics() }
}
