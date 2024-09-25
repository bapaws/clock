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
  /// Cleaning
  internal static let cleaning = L10n.tr("Localizable", "Cleaning", fallback: "Cleaning")
  /// Coding
  internal static let coding = L10n.tr("Localizable", "Coding", fallback: "Coding")
  /// Cooking
  internal static let cooking = L10n.tr("Localizable", "Cooking", fallback: "Cooking")
  /// Dota2
  internal static let dota2 = L10n.tr("Localizable", "Dota2", fallback: "Dota2")
  /// English
  internal static let english = L10n.tr("Localizable", "English", fallback: "English")
  /// Exam
  internal static let exam = L10n.tr("Localizable", "Exam", fallback: "Exam")
  /// Genshin
  internal static let genshin = L10n.tr("Localizable", "Genshin", fallback: "Genshin")
  /// Math
  internal static let math = L10n.tr("Localizable", "Math", fallback: "Math")
  /// Midday Nap
  internal static let middayNap = L10n.tr("Localizable", "MiddayNap", fallback: "Midday Nap")
  /// Music
  internal static let music = L10n.tr("Localizable", "Music", fallback: "Music")
  /// Personal Grooming
  internal static let personalGrooming = L10n.tr("Localizable", "PersonalGrooming", fallback: "Personal Grooming")
  /// Long press to select categories
  internal static let quickPreviewHint = L10n.tr("Localizable", "QuickPreviewHint", fallback: "Long press to select categories")
  /// Localizable.strings
  ///   Hours
  /// 
  ///   Created by 张敏超 on 2024/6/5.
  internal static let quickTiming = L10n.tr("Localizable", "QuickTiming", fallback: "Quick Timing")
  /// Reading
  internal static let reading = L10n.tr("Localizable", "Reading", fallback: "Reading")
  /// Running
  internal static let running = L10n.tr("Localizable", "Running", fallback: "Running")
  /// Shopping
  internal static let shopping = L10n.tr("Localizable", "Shopping", fallback: "Shopping")
  /// Sleep
  internal static let sleep = L10n.tr("Localizable", "Sleep", fallback: "Sleep")
  /// Swimming
  internal static let swimming = L10n.tr("Localizable", "Swimming", fallback: "Swimming")
  /// %@ Tracking
  internal static func tracking(_ p1: Any) -> String {
    return L10n.tr("Localizable", "Tracking", String(describing: p1), fallback: "%@ Tracking")
  }
  /// Travel
  internal static let travel = L10n.tr("Localizable", "Travel", fallback: "Travel")
  /// Video
  internal static let video = L10n.tr("Localizable", "Video", fallback: "Video")
  /// Work
  internal static let work = L10n.tr("Localizable", "Work", fallback: "Work")
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
