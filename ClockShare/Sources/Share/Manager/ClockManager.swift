//
//  ClockManager.swift
//
//
//  Created by 张敏超 on 2023/12/22.
//

import AVFoundation
import Combine
import Foundation
import SwiftUI

public enum SecondStyle: String, CaseIterable {
    case none
    case small
    case big
}

public enum DateStyle: Int, CaseIterable {
    case none = 0
    case short = 1
    case medium = 2
    case long = 3
    case full = 4

    var rawStyle: DateFormatter.Style {
        .init(rawValue: UInt(rawValue)) ?? .none
    }
}

public enum TimeFormat: Int, CaseIterable {
    case h24 = 24, h12 = 12
}

public class ClockManager: ObservableObject {
    public static let shared = ClockManager()

    @Published public private(set) var time: Time = .init()

    @AppStorage(Storage.Key.secondStyle)
    public var secondStyle: SecondStyle = .small

    @AppStorage(Storage.Key.timeFormat)
    public var timeFormat: TimeFormat = .h24

    @AppStorage(Storage.Key.dateStyle)
    public var dateStyle: DateStyle = .none

    public var timeInterval: TimeInterval = 0.5
    private var timer: Timer? = nil
    private init(time: Time = .init(), timeInterval: TimeInterval = 0.5) {
        self.time = time
        self.timeInterval = timeInterval
        start()
    }
}

// MARK: - Timer

public extension ClockManager {
    func start() {
        let timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            self?.time.toDate()
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    func suspendTimer() {
        timer?.fireDate = .distantFuture
    }

    func resumeTimer() {
        guard let timer = timer else { return }
        time.toDate()
        timer.fireDate = Date()
    }
}

// MARK: Digit

public extension ClockManager {
    var hourTens: Int {
        switch timeFormat {
        case .h12:
            time.hour12Tens
        case .h24:
            time.hour24Tens
        }
    }

    var hourOnes: Int {
        switch timeFormat {
        case .h12:
            time.hour12Ones
        case .h24:
            time.hour24Ones
        }
    }
}
