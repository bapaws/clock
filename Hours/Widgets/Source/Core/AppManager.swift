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
    }
}
