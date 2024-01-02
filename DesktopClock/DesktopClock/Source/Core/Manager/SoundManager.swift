//
//  SoundManager.swift
//  DesktopClock
//
//  Created by 张敏超 on 2023/12/31.
//

import AVFAudio
import Foundation

public enum SoundType: String, CaseIterable {
    case mute, card, drip, muyu, pendulum, `switch`, tick

    public static var title: String {
        R.string.localizable.darkMode()
    }

//    public var value: String {
//        switch self {
//        case .light:
//            R.string.localizable.light()
//        case .dark:
//            R.string.localizable.dark()
//        default:
//            R.string.localizable.modeAuto()
//        }
//    }
}

public class SoundManager {
    public static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func prepareToPlay() {
        guard let bundle = Bundle.main.path(forResource: "flip_sound_tick", ofType: "wav") else { return }
        let backgroundMusic = NSURL(fileURLWithPath: bundle)
        do {
            if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
                audioPlayer.stop()
            }

            audioPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.5
        } catch {
            print(error)
        }
    }

    func play() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
