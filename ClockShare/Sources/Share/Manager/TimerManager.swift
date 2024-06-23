//
//  TimerManager.swift
//
//
//  Created by 张敏超 on 2023/12/22.
//

import AVFoundation
import Combine
import Dependencies
import Foundation
import SwiftUI

open class TimerBaseManager: ObservableObject {
    @Published public var time: Time = .zero
    @Published public private(set) var isStarted: Bool = false
    @Published public private(set) var isPaused: Bool = false

    @AppStorage(Storage.Key.hourStyle, store: Storage.default.store)
    public var hourStyle: DigitStyle = .none

    @Dependency(\.date.now) var now

    public var timeInterval: TimeInterval = 0.5
    private var timer: Timer?

    public init(time: Time = .zero, timer: Timer? = nil) {
        self.time = time
        self.timer = timer
    }

    // MARK: - Timer

    open func start(time: Time = .zero) {
        stop()

        self.time = time
        timer = Timer(timeInterval: timeInterval, repeats: true, block: { [weak self] _ in
            withAnimation {
                self?.time++
            }
        })
        RunLoop.main.add(timer!, forMode: .common)

        isStarted = true
        isPaused = false
    }

    open func pause() {
        if isPaused { return }
        isPaused = true

        time.pause()
        timer?.fireDate = .distantFuture
    }

    open func resume() {
        guard isStarted, isPaused else { return }
        isPaused = false

        time.resume()
        timer?.fireDate = now
    }

    open func stop() {
        timer?.invalidate()
        timer = nil

        time = .zero

        isStarted = false
        isPaused = false
    }
}

// MARK: -

public extension TimerBaseManager {
    func suspendTimer() {
        timer?.fireDate = .distantFuture
    }

    func resumeTimer() {
        guard let timer = timer else { return }
        time++
        timer.fireDate = Date()
    }
}
