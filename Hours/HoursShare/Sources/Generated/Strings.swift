// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Afternoon Tea
  internal static let afternoonTea = L10n.tr("Localizable", "AfternoonTea", fallback: "Afternoon Tea")
  /// Blue
  internal static let blue = L10n.tr("Localizable", "Blue", fallback: "Blue")
  /// Break
  internal static let `break` = L10n.tr("Localizable", "Break", fallback: "Break")
  /// Cleaning
  internal static let cleaning = L10n.tr("Localizable", "Cleaning", fallback: "Cleaning")
  /// Coding
  internal static let coding = L10n.tr("Localizable", "Coding", fallback: "Coding")
  /// Cooking
  internal static let cooking = L10n.tr("Localizable", "Cooking", fallback: "Cooking")
  /// Cyan
  internal static let cyan = L10n.tr("Localizable", "Cyan", fallback: "Cyan")
  /// d
  internal static let days = L10n.tr("Localizable", "Days", fallback: "d")
  /// Dota2
  internal static let dota2 = L10n.tr("Localizable", "Dota2", fallback: "Dota2")
  /// English
  internal static let english = L10n.tr("Localizable", "English", fallback: "English")
  /// Entertainment
  internal static let entertainment = L10n.tr("Localizable", "Entertainment", fallback: "Entertainment")
  /// Exam
  internal static let exam = L10n.tr("Localizable", "Exam", fallback: "Exam")
  /// Game
  internal static let game = L10n.tr("Localizable", "Game", fallback: "Game")
  /// Genshin
  internal static let genshin = L10n.tr("Localizable", "Genshin", fallback: "Genshin")
  /// Green
  internal static let green = L10n.tr("Localizable", "Green", fallback: "Green")
  /// Health
  internal static let health = L10n.tr("Localizable", "Health", fallback: "Health")
  /// h
  internal static let hours = L10n.tr("Localizable", "Hours", fallback: "h")
  /// Housework
  internal static let housework = L10n.tr("Localizable", "Housework", fallback: "Housework")
  /// Life
  internal static let life = L10n.tr("Localizable", "Life", fallback: "Life")
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "Loading", fallback: "Loading...")
  /// Math
  internal static let math = L10n.tr("Localizable", "Math", fallback: "Math")
  /// min
  internal static let minutes = L10n.tr("Localizable", "Minutes", fallback: "min")
  /// Music
  internal static let music = L10n.tr("Localizable", "Music", fallback: "Music")
  /// Nap
  internal static let nap = L10n.tr("Localizable", "Nap", fallback: "Nap")
  /// Orange
  internal static let orange = L10n.tr("Localizable", "Orange", fallback: "Orange")
  /// Personal Grooming
  internal static let personalGrooming = L10n.tr("Localizable", "PersonalGrooming", fallback: "Personal Grooming")
  /// Purple
  internal static let purple = L10n.tr("Localizable", "Purple", fallback: "Purple")
  /// Reading
  internal static let reading = L10n.tr("Localizable", "Reading", fallback: "Reading")
  /// Red
  internal static let red = L10n.tr("Localizable", "Red", fallback: "Red")
  /// Running
  internal static let running = L10n.tr("Localizable", "Running", fallback: "Running")
  /// s
  internal static let seconds = L10n.tr("Localizable", "Seconds", fallback: "s")
  /// Shopping
  internal static let shopping = L10n.tr("Localizable", "Shopping", fallback: "Shopping")
  /// Sleep
  internal static let sleep = L10n.tr("Localizable", "Sleep", fallback: "Sleep")
  /// Sports
  internal static let sports = L10n.tr("Localizable", "Sports", fallback: "Sports")
  /// Study
  internal static let study = L10n.tr("Localizable", "Study", fallback: "Study")
  /// Swimming
  internal static let swimming = L10n.tr("Localizable", "Swimming", fallback: "Swimming")
  /// Localizable.strings
  ///   Counter
  /// 
  ///   Created by 张敏超 on 2024/3/3.
  internal static let today = L10n.tr("Localizable", "Today", fallback: "Today")
  /// Travel
  internal static let travel = L10n.tr("Localizable", "Travel", fallback: "Travel")
  /// Video
  internal static let video = L10n.tr("Localizable", "Video", fallback: "Video")
  /// Work
  internal static let work = L10n.tr("Localizable", "Work", fallback: "Work")
  /// Yellow
  internal static let yellow = L10n.tr("Localizable", "Yellow", fallback: "Yellow")
  /// Yesterday
  internal static let yesterday = L10n.tr("Localizable", "Yesterday", fallback: "Yesterday")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
