//
//  File.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import ClockShare
import Foundation
import SwiftUI

public class AppManager: ObservableObject {
    public static let shared = AppManager()

    @AppStorage(Storage.Key.soundType)
    public var soundType: SoundType = .tick {
        didSet {}
    }

    
}


// MARK: Sound

public extension AppManager {
    
}
