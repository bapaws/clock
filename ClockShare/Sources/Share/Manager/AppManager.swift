//
//  AppManager.swift
//
//
//  Created by 张敏超 on 2024/1/20.
//

import AVFoundation
import SwiftUI
import UIKit

public enum SoundType: String, CaseIterable {
//    case tick, pendulum, card, drip, muyu, `switch`
    case tick, second, drip
}

public enum AppPage: Int, CaseIterable {
    case pomodoro, clock, timer
}

open class AppBaseManager: ObservableObject {
    @AppStorage(Storage.Key.isMute, store: Storage.default.store)
    public var isMute: Bool = true

    @AppStorage(Storage.Key.soundType, store: Storage.default.store)
    public var soundType: SoundType = .tick {
        didSet {
            audioPlayerQueue.async {
                self.audioPlayer?.stop()
                self.prepareAudioPlayer()
            }
        }
    }

    @AppStorage(Storage.Key.idleTimerDisabled, store: Storage.default.store)
    public var idleTimerDisabled: Bool = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }

    public var launchCount: Int {
        set { Storage.default.launchedCount = newValue }
        get { Storage.default.launchedCount }
    }

    public let audioPlayerQueue = DispatchQueue(label: "com.bapaws.AudioPlayer")
    public private(set) var audioPlayer: AVAudioPlayer?
    public var isPomodoroStopped: Bool = true
    public var isClockStopped: Bool = false
    public var isTimerStopped: Bool = true

    public private(set) var page: AppPage = .clock

    public init() {
        // Prepare Clock
        audioPlayerQueue.async(execute: prepareAudioPlayer)
    }

    open func suspend() {
        fatalError()
    }

    open func resume() {
        fatalError()
    }
}

// MARK: App Page

public extension AppBaseManager {
    func onPageWillChange(index: Int) {
        page = AppPage(rawValue: index) ?? .clock

        resume()
    }
}

// MARK: Sound

public extension AppBaseManager {
    private func prepareAudioPlayer() {
        guard let bundle = Bundle.main.path(forResource: "\(soundType.rawValue)", ofType: "wav") else { return }
        let backgroundMusic = URL(fileURLWithPath: bundle)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
            audioPlayer?.prepareToPlay()
        } catch {
            print(error)
        }
    }

    private func stopAllPlayer() {
        isPomodoroStopped = true
        isClockStopped = true
        isTimerStopped = true
        audioPlayerQueue.async {
            self.audioPlayer?.stop()
        }
    }

    func playPomodoro() {
        if isMute || isPomodoroStopped { return }
        audioPlayerQueue.async {
            self.audioPlayer?.play()
        }
    }

    func playClock() {
        if isMute || isClockStopped { return }
        audioPlayerQueue.async {
            self.audioPlayer?.play()
        }
    }

    func playTimer() {
        if isMute || isTimerStopped { return }
        audioPlayerQueue.async {
            self.audioPlayer?.play()
        }
    }
}
