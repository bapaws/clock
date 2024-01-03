//
//  File.swift
//
//
//  Created by 张敏超 on 2023/12/23.
//

import AVFoundation
import ClockShare
import Foundation
import SwiftUI

public enum SoundType: String, CaseIterable {
//    case tick, pendulum, card, drip, muyu, `switch`
    case tick, second, drip

    public var value: String {
        switch self {
        case .tick:
            R.string.localizable.tick()

        case .second:
            R.string.localizable.secondHand()
        case .drip:

            R.string.localizable.drip()
        }
//        switch self {
//        case .card:
//            R.string.localizable.card()
//        case .drip:
//            R.string.localizable.drip()
//        case .muyu:
//            R.string.localizable.muyu()
//        case .pendulum:
//            R.string.localizable.pendulum()
//        case .switch:
//            R.string.localizable.switch()
//        case .tick:
//            R.string.localizable.tick()
//        }
    }
}

public enum AppPage: Int, CaseIterable {
    case pomodoro, clock, timer
}

public class AppManager: ObservableObject {
    public static let shared = AppManager()

    @AppStorage(Storage.Key.isMute)
    public var isMute: Bool = false

    @AppStorage(Storage.Key.soundType)
    public var soundType: SoundType = .tick {
        didSet {
            audioPlayerQueue.async {
                self.audioPlayer?.stop()
                self.prepareAudioPlayer()
            }
        }
    }

    @AppStorage(Storage.Key.idleTimerDisabled)
    public var idleTimerDisabled: Bool = true {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = idleTimerDisabled
        }
    }

    let audioPlayerQueue = DispatchQueue(label: "com.bapaws.AudioPlayer")
    private var audioPlayer: AVAudioPlayer?
    private var isPomodoroStopped: Bool = true
    private var isClockStopped: Bool = false
    private var isTimerStopped: Bool = true

    private var page: AppPage = .clock

    private init() {
        // Prepare Clock
        audioPlayerQueue.async(execute: prepareAudioPlayer)
    }
}

// MARK: App Page

public extension AppManager {
    func onPageWillChange(index: Int) {
        page = AppPage(rawValue: index) ?? .clock

        resume()
    }
}

public extension AppManager {
    func suspend() {
        ClockManager.shared.suspendTimer()
        PomodoroManager.shared.suspendTimer()
        TimerManager.shared.suspendTimer()

        isPomodoroStopped = true
        isClockStopped = true
        isTimerStopped = true
        audioPlayerQueue.async {
            self.audioPlayer?.stop()
        }
    }

    func resume() {
        switch page {
        case .pomodoro:
            isPomodoroStopped = false
            isClockStopped = true
            isTimerStopped = true

            PomodoroManager.shared.resumeTimer()
            ClockManager.shared.suspendTimer()
            TimerManager.shared.suspendTimer()
        case .clock:
            isPomodoroStopped = true
            isClockStopped = false
            isTimerStopped = true

            PomodoroManager.shared.suspendTimer()
            ClockManager.shared.resumeTimer()
            TimerManager.shared.suspendTimer()
        case .timer:
            isPomodoroStopped = true
            isClockStopped = true
            isTimerStopped = false

            PomodoroManager.shared.suspendTimer()
            ClockManager.shared.suspendTimer()
            TimerManager.shared.resumeTimer()
        }
    }
}

// MARK: Sound

public extension AppManager {
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
