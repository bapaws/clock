//
//  File.swift
//
//
//  Created by 张敏超 on 2024/5/11.
//

import ClockShare
import Foundation

public extension Storage.Key {
    static let hexIndex = "hexIndex"
    static let onboardingVersion = "onboardingVersion"

    static let isAutoSyncWorkout = "isAutoSyncWorkout"
    static let lastSyncWorkoutDate = "lastSyncWorkoutDate"
    static let isAutoSyncSleep = "isAutoSyncSleep"
    static let lastSyncSleepDate = "lastSyncSleepDate"

    static let currentTimerTime = "currentTimerTime"
    static let currentTimerEventID = "currentTimerEventID"
}

public extension Storage {
    var hexIndex: Int? {
        set {
            if let index = newValue {
                store.set(index, forKey: Key.hexIndex)
            } else {
                store.removeObject(forKey: Key.hexIndex)
            }
        }
        get {
            store.object(forKey: Key.hexIndex) as? Int
        }
    }

    var onboardingVersion: Int {
        set {
            store.set(newValue, forKey: Key.onboardingVersion)
        }
        get {
            store.integer(forKey: Key.onboardingVersion)
        }
    }

    var lastSyncWorkoutDate: Date? {
        set { store.set(newValue, forKey: Key.lastSyncWorkoutDate) }
        get { store.object(forKey: Key.lastSyncWorkoutDate) as? Date }
    }

    var lastSyncSleepDate: Date? {
        set { store.set(newValue, forKey: Key.lastSyncSleepDate) }
        get { store.object(forKey: Key.lastSyncSleepDate) as? Date }
    }

    var currentTimerTime: Time? {
        set {
            if let time = newValue {
                let data = try? JSONEncoder().encode(time)
                store.set(data, forKey: Key.currentTimerTime)
            } else {
                store.removeObject(forKey: Key.currentTimerTime)
            }
        }
        get {
            guard let data = store.object(forKey: Key.currentTimerTime) as? Data else { return nil }
            return try? JSONDecoder().decode(Time.self, from: data)
        }
    }

    var currentTimerEventID: String? {
        set { store.set(newValue, forKey: Key.currentTimerEventID) }
        get { store.string(forKey: Key.currentTimerEventID) }
    }
}
