// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// About
  internal static let about = L10n.tr("Localizable", "About", fallback: "About")
  /// Adjacent Records
  internal static let adjacentRecords = L10n.tr("Localizable", "AdjacentRecords", fallback: "Adjacent Records")
  /// Afternoon Tea
  internal static let afternoonTea = L10n.tr("Localizable", "AfternoonTea", fallback: "Afternoon Tea")
  /// All
  internal static let all = L10n.tr("Localizable", "All", fallback: "All")
  /// AM
  internal static let am = L10n.tr("Localizable", "AM", fallback: "AM")
  ///  and 
  internal static let and = L10n.tr("Localizable", "And", fallback: " and ")
  /// App Did Close
  internal static let appDidClose = L10n.tr("Localizable", "AppDidClose", fallback: "App Did Close")
  /// App Did Open
  internal static let appDidOpen = L10n.tr("Localizable", "AppDidOpen", fallback: "App Did Open")
  /// Appearance
  internal static let appearance = L10n.tr("Localizable", "Appearance", fallback: "Appearance")
  /// App Icon
  internal static let appIcon = L10n.tr("Localizable", "AppIcon", fallback: "App Icon")
  /// Localizable.strings
  ///   Counter
  /// 
  ///   Created by 张敏超 on 2024/3/3.
  internal static let appName = L10n.tr("Localizable", "AppName", fallback: "Hours")
  /// App Screen Time
  internal static let appScreenTime = L10n.tr("Localizable", "AppScreenTime", fallback: "App Screen Time")
  /// Auto-record your screen time. Just set up the Shortcuts app on iOS to listen for our app's open and close events. It's that simple!
  internal static let appScreenTimeDesc = L10n.tr("Localizable", "AppScreenTimeDesc", fallback: "Auto-record your screen time. Just set up the Shortcuts app on iOS to listen for our app's open and close events. It's that simple!")
  /// Record App Screen Time
  internal static let appScreenTimeTitle = L10n.tr("Localizable", "AppScreenTimeTitle", fallback: "Record App Screen Time")
  /// Archive
  internal static let archive = L10n.tr("Localizable", "Archive", fallback: "Archive")
  /// Archived
  internal static let archived = L10n.tr("Localizable", "Archived", fallback: "Archived")
  /// Archived At: %@
  internal static func archivedAt(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ArchivedAt", String(describing: p1), fallback: "Archived At: %@")
  }
  /// %@ Archived Events
  internal static func archivedEvents(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ArchivedEvents", String(describing: p1), fallback: "%@ Archived Events")
  }
  /// Auto Merge Adjacent Records
  internal static let autoMergeAdjacentRecords = L10n.tr("Localizable", "AutoMergeAdjacentRecords", fallback: "Auto Merge Adjacent Records")
  /// Auto-Record Setup Guide
  internal static let autoRecordSetupGuide = L10n.tr("Localizable", "AutoRecordSetupGuide", fallback: "Auto-Record Setup Guide")
  /// Background Sound
  internal static let backgroundSound = L10n.tr("Localizable", "BackgroundSound", fallback: "Background Sound")
  /// Break
  internal static let `break` = L10n.tr("Localizable", "Break", fallback: "Break")
  /// Break has finished，Keep fighting!💪💪💪
  internal static let breakCompletedNotification = L10n.tr("Localizable", "BreakCompletedNotification", fallback: "Break has finished，Keep fighting!💪💪💪")
  /// Please allow Hours access to your calendar so that you can see your time consumption in Apple Calendar.
  internal static let calendarDesc = L10n.tr("Localizable", "CalendarDesc", fallback: "Please allow Hours access to your calendar so that you can see your time consumption in Apple Calendar.")
  /// Hours cannot access Calendar and can be turned on in settings later.
  internal static let calendarNotAccess = L10n.tr("Localizable", "CalendarNotAccess", fallback: "Hours cannot access Calendar and can be turned on in settings later.")
  /// Use with Apple Calendar
  internal static let calendarTitle = L10n.tr("Localizable", "CalendarTitle", fallback: "Use with Apple Calendar")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Cancel")
  /// Card
  internal static let card = L10n.tr("Localizable", "Card", fallback: "Card")
  /// Category
  internal static let category = L10n.tr("Localizable", "Category", fallback: "Category")
  /// Category Name
  internal static let categoryName = L10n.tr("Localizable", "CategoryName", fallback: "Category Name")
  /// Classic
  internal static let classic = L10n.tr("Localizable", "Classic", fallback: "Classic")
  /// Cleaning
  internal static let cleaning = L10n.tr("Localizable", "Cleaning", fallback: "Cleaning")
  /// Clock
  internal static let clock = L10n.tr("Localizable", "Clock", fallback: "Clock")
  /// Coding
  internal static let coding = L10n.tr("Localizable", "Coding", fallback: "Coding")
  /// Collapse
  internal static let collapse = L10n.tr("Localizable", "Collapse", fallback: "Collapse")
  /// Color
  internal static let color = L10n.tr("Localizable", "Color", fallback: "Color")
  /// Color Themes
  internal static let colorThemes = L10n.tr("Localizable", "ColorThemes", fallback: "Color Themes")
  /// Congratulations! 👏👏👏
  internal static let congratulations = L10n.tr("Localizable", "Congratulations", fallback: "Congratulations! 👏👏👏")
  /// Continue
  internal static let `continue` = L10n.tr("Localizable", "Continue", fallback: "Continue")
  /// Cooking
  internal static let cooking = L10n.tr("Localizable", "Cooking", fallback: "Cooking")
  /// Daily Input
  internal static let dailyInput = L10n.tr("Localizable", "DailyInput", fallback: "Daily Input")
  /// Dark
  internal static let dark = L10n.tr("Localizable", "Dark", fallback: "Dark")
  /// Classic Dark
  internal static let darkClassic = L10n.tr("Localizable", "DarkClassic", fallback: "Classic Dark")
  /// Dark Mode
  internal static let darkMode = L10n.tr("Localizable", "DarkMode", fallback: "Dark Mode")
  /// Day
  internal static let day = L10n.tr("Localizable", "Day", fallback: "Day")
  /// d
  internal static let days = L10n.tr("Localizable", "Days", fallback: "d")
  /// Default
  internal static let `default` = L10n.tr("Localizable", "Default", fallback: "Default")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "Delete", fallback: "Delete")
  /// Are you sure you want to delete "%@"? 
  ///  All events & records of "%@" will also be deleted together.
  internal static func deleteCategoryWarning(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "DeleteCategoryWarning", String(describing: p1), String(describing: p2), fallback: "Are you sure you want to delete \"%@\"? \n All events & records of \"%@\" will also be deleted together.")
  }
  /// Delete all events first.
  internal static let deleteEventsFirst = L10n.tr("Localizable", "DeleteEventsFirst", fallback: "Delete all events first.")
  /// Are you sure you want to delete "%@"? 
  ///  All records of "%@" will also be deleted together.
  internal static func deleteEventWarning(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "DeleteEventWarning", String(describing: p1), String(describing: p2), fallback: "Are you sure you want to delete \"%@\"? \n All records of \"%@\" will also be deleted together.")
  }
  /// Dota2
  internal static let dota2 = L10n.tr("Localizable", "Dota2", fallback: "Dota2")
  /// Drip
  internal static let drip = L10n.tr("Localizable", "Drip", fallback: "Drip")
  /// Duration
  internal static let duration = L10n.tr("Localizable", "Duration", fallback: "Duration")
  /// Edit
  internal static let edit = L10n.tr("Localizable", "Edit", fallback: "Edit")
  /// Edit Category
  internal static let editCategory = L10n.tr("Localizable", "EditCategory", fallback: "Edit Category")
  /// Edit Event
  internal static let editEvent = L10n.tr("Localizable", "EditEvent", fallback: "Edit Event")
  /// Edit Record
  internal static let editRecord = L10n.tr("Localizable", "EditRecord", fallback: "Edit Record")
  /// Email
  internal static let email = L10n.tr("Localizable", "Email", fallback: "Email")
  /// Email address has been copied.
  internal static let emailCopied = L10n.tr("Localizable", "EmailCopied", fallback: "Email address has been copied.")
  /// <p>ℹ️Info：</p><ul><li>System Name: %@</li><li>System Version: %@</li><li>Model: %@</li><li>App Version: %@</li></ul><p>Issues：</p><p></p>
  internal static func emailMessageBody(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any) -> String {
    return L10n.tr("Localizable", "EmailMessageBody", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), fallback: "<p>ℹ️Info：</p><ul><li>System Name: %@</li><li>System Version: %@</li><li>Model: %@</li><li>App Version: %@</li></ul><p>Issues：</p><p></p>")
  }
  /// Emoji
  internal static let emoji = L10n.tr("Localizable", "Emoji", fallback: "Emoji")
  /// End Time
  internal static let endTime = L10n.tr("Localizable", "EndTime", fallback: "End Time")
  /// English
  internal static let english = L10n.tr("Localizable", "English", fallback: "English")
  /// Entertainment
  internal static let entertainment = L10n.tr("Localizable", "Entertainment", fallback: "Entertainment")
  /// Event
  internal static let event = L10n.tr("Localizable", "Event", fallback: "Event")
  /// Event Name
  internal static let eventName = L10n.tr("Localizable", "EventName", fallback: "Event Name")
  /// Events
  internal static let events = L10n.tr("Localizable", "Events", fallback: "Events")
  /// Exam
  internal static let exam = L10n.tr("Localizable", "Exam", fallback: "Exam")
  /// Expand
  internal static let expand = L10n.tr("Localizable", "Expand", fallback: "Expand")
  /// Feedback
  internal static let feedback = L10n.tr("Localizable", "Feedback", fallback: "Feedback")
  /// Finish
  internal static let finish = L10n.tr("Localizable", "Finish", fallback: "Finish")
  /// Congratulations! Keep going!👏👏👏
  internal static let focusCompletedNotification = L10n.tr("Localizable", "FocusCompletedNotification", fallback: "Congratulations! Keep going!👏👏👏")
  /// Focus Duration
  internal static let focusDuration = L10n.tr("Localizable", "FocusDuration", fallback: "Focus Duration")
  /// Game
  internal static let game = L10n.tr("Localizable", "Game", fallback: "Game")
  /// Genshin
  internal static let genshin = L10n.tr("Localizable", "Genshin", fallback: "Genshin")
  /// Get Pro
  internal static let getPro = L10n.tr("Localizable", "GetPro", fallback: "Get Pro")
  /// Health
  internal static let health = L10n.tr("Localizable", "Health", fallback: "Health")
  /// Auto Sync Sleep
  internal static let healthAutoSyncSleep = L10n.tr("Localizable", "HealthAutoSyncSleep", fallback: "Auto Sync Sleep")
  /// Auto Sync Workout
  internal static let healthAutoSyncWorkout = L10n.tr("Localizable", "HealthAutoSyncWorkout", fallback: "Auto Sync Workout")
  /// Please allow Hours access to your Health, So that your sleep and workout records can be automatically synchronized.
  internal static let healthDesc = L10n.tr("Localizable", "HealthDesc", fallback: "Please allow Hours access to your Health, So that your sleep and workout records can be automatically synchronized.")
  /// Hours cannot access Health and can be turned on in settings later.
  internal static let healthNotAccess = L10n.tr("Localizable", "HealthNotAccess", fallback: "Hours cannot access Health and can be turned on in settings later.")
  /// Record Sleep & Workout
  internal static let healthTitle = L10n.tr("Localizable", "HealthTitle", fallback: "Record Sleep & Workout")
  /// Heat Map
  internal static let heatMap = L10n.tr("Localizable", "HeatMap", fallback: "Heat Map")
  /// h
  internal static let hours = L10n.tr("Localizable", "Hours", fallback: "h")
  /// Housework
  internal static let housework = L10n.tr("Localizable", "Housework", fallback: "Housework")
  /// Icon
  internal static let icon = L10n.tr("Localizable", "Icon", fallback: "Icon")
  /// Import From Calendar
  internal static let importFromCalendar = L10n.tr("Localizable", "ImportFromCalendar", fallback: "Import From Calendar")
  /// Importing...
  internal static let importing = L10n.tr("Localizable", "Importing", fallback: "Importing...")
  /// Import Records
  internal static let importRecords = L10n.tr("Localizable", "ImportRecords", fallback: "Import Records")
  /// Interval
  internal static let interval = L10n.tr("Localizable", "Interval", fallback: "Interval")
  /// Last 7 Days
  internal static let last7Days = L10n.tr("Localizable", "Last7Days", fallback: "Last 7 Days")
  /// Leave
  internal static let leave = L10n.tr("Localizable", "Leave", fallback: "Leave")
  /// Life
  internal static let life = L10n.tr("Localizable", "Life", fallback: "Life")
  /// Light
  internal static let light = L10n.tr("Localizable", "Light", fallback: "Light")
  /// Classic Light
  internal static let lightClassic = L10n.tr("Localizable", "LightClassic", fallback: "Classic Light")
  /// Light Mode
  internal static let lightMode = L10n.tr("Localizable", "LightMode", fallback: "Light Mode")
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "Loading", fallback: "Loading...")
  /// Long Break Duration
  internal static let longBreakDuration = L10n.tr("Localizable", "LongBreakDuration", fallback: "Long Break Duration")
  /// Math
  internal static let math = L10n.tr("Localizable", "Math", fallback: "Math")
  /// Maximum Recorded Time
  internal static let maximumRecordedTime = L10n.tr("Localizable", "MaximumRecordedTime", fallback: "Maximum Recorded Time")
  /// Midday Nap
  internal static let middayNap = L10n.tr("Localizable", "MiddayNap", fallback: "Midday Nap")
  /// Minimum Recorded Time
  internal static let minimumRecordedTime = L10n.tr("Localizable", "MinimumRecordedTime", fallback: "Minimum Recorded Time")
  /// min
  internal static let minutes = L10n.tr("Localizable", "Minutes", fallback: "min")
  /// Use Device Setting
  internal static let modeAuto = L10n.tr("Localizable", "ModeAuto", fallback: "Use Device Setting")
  /// Month
  internal static let month = L10n.tr("Localizable", "Month", fallback: "Month")
  /// Monthly
  internal static let monthly = L10n.tr("Localizable", "Monthly", fallback: "Monthly")
  /// Music
  internal static let music = L10n.tr("Localizable", "Music", fallback: "Music")
  /// Mute
  internal static let mute = L10n.tr("Localizable", "Mute", fallback: "Mute")
  /// Mokugyo
  internal static let muyu = L10n.tr("Localizable", "Muyu", fallback: "Mokugyo")
  /// New Category
  internal static let newCategory = L10n.tr("Localizable", "NewCategory", fallback: "New Category")
  /// New Event
  internal static let newEvent = L10n.tr("Localizable", "NewEvent", fallback: "New Event")
  /// New Record
  internal static let newRecord = L10n.tr("Localizable", "NewRecord", fallback: "New Record")
  /// Note
  internal static let note = L10n.tr("Localizable", "Note", fallback: "Note")
  /// Onboarding
  internal static let onboarding = L10n.tr("Localizable", "Onboarding", fallback: "Onboarding")
  /// Orange
  internal static let orange = L10n.tr("Localizable", "Orange", fallback: "Orange")
  /// Other
  internal static let other = L10n.tr("Localizable", "Other", fallback: "Other")
  /// Overall
  internal static let overall = L10n.tr("Localizable", "Overall", fallback: "Overall")
  /// Pendulum
  internal static let pendulum = L10n.tr("Localizable", "Pendulum", fallback: "Pendulum")
  /// Personal Grooming
  internal static let personalGrooming = L10n.tr("Localizable", "PersonalGrooming", fallback: "Personal Grooming")
  /// Pink
  internal static let pink = L10n.tr("Localizable", "Pink", fallback: "Pink")
  /// Add records via timer or pomodoro.
  internal static let playButtonTipMessage = L10n.tr("Localizable", "PlayButtonTipMessage", fallback: "Add records via timer or pomodoro.")
  /// Start a timer or pomodoro
  internal static let playButtonTipTitle = L10n.tr("Localizable", "PlayButtonTipTitle", fallback: "Start a timer or pomodoro")
  /// Please enter...
  internal static let pleaseEnter = L10n.tr("Localizable", "PleaseEnter", fallback: "Please enter...")
  /// Please select...
  internal static let pleaseSelect = L10n.tr("Localizable", "PleaseSelect", fallback: "Please select...")
  /// PM
  internal static let pm = L10n.tr("Localizable", "PM", fallback: "PM")
  /// Pomodoro
  internal static let pomodoro = L10n.tr("Localizable", "Pomodoro", fallback: "Pomodoro")
  /// Hours Premium
  internal static let premium = L10n.tr("Localizable", "Premium", fallback: "Hours Premium")
  /// Privacy Policy
  internal static let privacy = L10n.tr("Localizable", "Privacy", fallback: "Privacy Policy")
  /// Unlock statistics features
  internal static let proInfo1 = L10n.tr("Localizable", "ProInfo1", fallback: "Unlock statistics features")
  /// Remove in-app ads
  internal static let proInfo2 = L10n.tr("Localizable", "ProInfo2", fallback: "Remove in-app ads")
  /// More personalization
  internal static let proInfo3 = L10n.tr("Localizable", "ProInfo3", fallback: "More personalization")
  /// More surprise features in the future.
  internal static let proInfo4 = L10n.tr("Localizable", "ProInfo4", fallback: "More surprise features in the future.")
  /// Pro Membership
  internal static let proMembership = L10n.tr("Localizable", "ProMembership", fallback: "Pro Membership")
  /// Purple
  internal static let purple = L10n.tr("Localizable", "Purple", fallback: "Purple")
  /// Rate Our App
  internal static let rate = L10n.tr("Localizable", "Rate", fallback: "Rate Our App")
  /// Reading
  internal static let reading = L10n.tr("Localizable", "Reading", fallback: "Reading")
  /// Recent
  internal static let recent = L10n.tr("Localizable", "Recent", fallback: "Recent")
  /// Record Count
  internal static let recordCount = L10n.tr("Localizable", "RecordCount", fallback: "Record Count")
  /// Records
  internal static let records = L10n.tr("Localizable", "Records", fallback: "Records")
  /// RED
  internal static let redBook = L10n.tr("Localizable", "RedBook", fallback: "RED")
  /// Restore
  internal static let restore = L10n.tr("Localizable", "Restore", fallback: "Restore")
  /// Running
  internal static let running = L10n.tr("Localizable", "Running", fallback: "Running")
  /// SALE
  internal static let sale = L10n.tr("Localizable", "Sale", fallback: "SALE")
  /// Save
  internal static let save = L10n.tr("Localizable", "Save", fallback: "Save")
  /// Second Hand
  internal static let secondHand = L10n.tr("Localizable", "SecondHand", fallback: "Second Hand")
  /// s
  internal static let seconds = L10n.tr("Localizable", "Seconds", fallback: "s")
  /// Select All
  internal static let selectAll = L10n.tr("Localizable", "Select All", fallback: "Select All")
  /// Select Category
  internal static let selectCategory = L10n.tr("Localizable", "SelectCategory", fallback: "Select Category")
  /// Select Emoji
  internal static let selectEmoji = L10n.tr("Localizable", "SelectEmoji", fallback: "Select Emoji")
  /// Select Event
  internal static let selectEvent = L10n.tr("Localizable", "SelectEvent", fallback: "Select Event")
  /// Send an email
  internal static let sendEmail = L10n.tr("Localizable", "SendEmail", fallback: "Send an email")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
  /// Set up later
  internal static let setupLater = L10n.tr("Localizable", "SetupLater", fallback: "Set up later")
  /// Shopping
  internal static let shopping = L10n.tr("Localizable", "Shopping", fallback: "Shopping")
  /// Break
  internal static let shortBreakDuration = L10n.tr("Localizable", "ShortBreakDuration", fallback: "Break")
  /// Show All
  internal static let showAll = L10n.tr("Localizable", "ShowAll", fallback: "Show All")
  /// Always Display Hours
  internal static let showHour = L10n.tr("Localizable", "ShowHour", fallback: "Always Display Hours")
  /// Display Seconds
  internal static let showSecond = L10n.tr("Localizable", "ShowSecond", fallback: "Display Seconds")
  /// Sleep
  internal static let sleep = L10n.tr("Localizable", "Sleep", fallback: "Sleep")
  /// Let time hold more value.
  internal static let slogan = L10n.tr("Localizable", "Slogan", fallback: "Let time hold more value.")
  /// Sound
  internal static let sound = L10n.tr("Localizable", "Sound", fallback: "Sound")
  /// Sports
  internal static let sports = L10n.tr("Localizable", "Sports", fallback: "Sports")
  /// Start Break
  internal static let startBreak = L10n.tr("Localizable", "StartBreak", fallback: "Start Break")
  /// Start Importing
  internal static let startImporting = L10n.tr("Localizable", "StartImporting", fallback: "Start Importing")
  /// Start Pomodoro
  internal static let startPomodoro = L10n.tr("Localizable", "StartPomodoro", fallback: "Start Pomodoro")
  /// Start Time
  internal static let startTime = L10n.tr("Localizable", "StartTime", fallback: "Start Time")
  /// Start Timer
  internal static let startTimer = L10n.tr("Localizable", "StartTimer", fallback: "Start Timer")
  /// Statistics
  internal static let statistics = L10n.tr("Localizable", "Statistics", fallback: "Statistics")
  /// Unlock deep insights into time management, customize your daily productivity, and achieve your goals with our Statistics Pro – making every moment count.
  internal static let statisticsDesc = L10n.tr("Localizable", "StatisticsDesc", fallback: "Unlock deep insights into time management, customize your daily productivity, and achieve your goals with our Statistics Pro – making every moment count.")
  /// Statistics Pro
  internal static let statisticsTitle = L10n.tr("Localizable", "StatisticsTitle", fallback: "Statistics Pro")
  /// Study
  internal static let study = L10n.tr("Localizable", "Study", fallback: "Study")
  /// After confirming the purchase, your Apple account will be charged, and the subscription will be automatically renewed if you purchase a monthly or yearly subscription, your Apple account will be charged 24 hours before the expiration date, and the subscription cycle will be postponed to the next subscription cycle after the successful deduction of the charge.
  /// If you want to cancel the automatic subscription, please turn off the auto-renewal function 24 hours before the end of the current subscription cycle. You can cancel your subscription by going to "Settings" --> click "Apple ID", click "Subscribe" and select "Desktop Clock" to unsubscribe.
  /// If the recharge does not arrive, please send your Apple ID and debit voucher to dev@bapaws.com.
  /// Pro member ad-free service temporarily includes the removal of app opening screen ads, banner ads.
  /// Pro member service is an online commodity and virtual commodity, once opened can not be refunded, thank you for your understanding and support.
  internal static let subscriptionWarning = L10n.tr("Localizable", "subscriptionWarning", fallback: "After confirming the purchase, your Apple account will be charged, and the subscription will be automatically renewed if you purchase a monthly or yearly subscription, your Apple account will be charged 24 hours before the expiration date, and the subscription cycle will be postponed to the next subscription cycle after the successful deduction of the charge.\nIf you want to cancel the automatic subscription, please turn off the auto-renewal function 24 hours before the end of the current subscription cycle. You can cancel your subscription by going to \"Settings\" --> click \"Apple ID\", click \"Subscribe\" and select \"Desktop Clock\" to unsubscribe.\nIf the recharge does not arrive, please send your Apple ID and debit voucher to dev@bapaws.com.\nPro member ad-free service temporarily includes the removal of app opening screen ads, banner ads.\nPro member service is an online commodity and virtual commodity, once opened can not be refunded, thank you for your understanding and support.")
  /// Summary
  internal static let summary = L10n.tr("Localizable", "Summary", fallback: "Summary")
  /// Swimming
  internal static let swimming = L10n.tr("Localizable", "Swimming", fallback: "Swimming")
  /// Switch
  internal static let `switch` = L10n.tr("Localizable", "Switch", fallback: "Switch")
  /// Sync records to Calendar
  internal static let syncRecordsToCalendar = L10n.tr("Localizable", "SyncRecordsToCalendar", fallback: "Sync records to Calendar")
  /// Terms of Use
  internal static let terms = L10n.tr("Localizable", "Terms", fallback: "Terms of Use")
  /// This Month, %@
  internal static func thisMonth(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ThisMonth", String(describing: p1), fallback: "This Month, %@")
  }
  /// This Week, %@
  internal static func thisWeek(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ThisWeek", String(describing: p1), fallback: "This Week, %@")
  }
  /// This Year, %@
  internal static func thisYear(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ThisYear", String(describing: p1), fallback: "This Year, %@")
  }
  /// Tick
  internal static let tick = L10n.tr("Localizable", "Tick", fallback: "Tick")
  /// Time
  internal static let time = L10n.tr("Localizable", "Time", fallback: "Time")
  /// Time Distribution
  internal static let timeDistribution = L10n.tr("Localizable", "TimeDistribution", fallback: "Time Distribution")
  /// Time Format
  internal static let timeFormat = L10n.tr("Localizable", "TimeFormat", fallback: "Time Format")
  /// Time Invest
  internal static let timeInvest = L10n.tr("Localizable", "TimeInvest", fallback: "Time Invest")
  /// Timer
  internal static let timer = L10n.tr("Localizable", "Timer", fallback: "Timer")
  /// Timing Mode
  internal static let timingMode = L10n.tr("Localizable", "TimingMode", fallback: "Timing Mode")
  /// Today
  internal static let today = L10n.tr("Localizable", "Today", fallback: "Today")
  /// Total
  internal static let total = L10n.tr("Localizable", "Total", fallback: "Total")
  /// Total Invest
  internal static let totalInvest = L10n.tr("Localizable", "TotalInvest", fallback: "Total Invest")
  /// %@ Tracking
  internal static func tracking(_ p1: Any) -> String {
    return L10n.tr("Localizable", "Tracking", String(describing: p1), fallback: "%@ Tracking")
  }
  /// Travel
  internal static let travel = L10n.tr("Localizable", "Travel", fallback: "Travel")
  /// Try Free
  internal static let tryFree = L10n.tr("Localizable", "TryFree", fallback: "Try Free")
  /// Unarchive
  internal static let unarchive = L10n.tr("Localizable", "Unarchive", fallback: "Unarchive")
  /// %@ Events
  internal static func unarchivedEvents(_ p1: Any) -> String {
    return L10n.tr("Localizable", "UnarchivedEvents", String(describing: p1), fallback: "%@ Events")
  }
  /// Unlock all premium features.
  internal static let unlockPro = L10n.tr("Localizable", "UnlockPro", fallback: "Unlock all premium features.")
  /// Unselect All
  internal static let unselectAll = L10n.tr("Localizable", "Unselect All", fallback: "Unselect All")
  /// Upgrade
  internal static let upgrade = L10n.tr("Localizable", "Upgrade", fallback: "Upgrade")
  /// Video
  internal static let video = L10n.tr("Localizable", "Video", fallback: "Video")
  /// ⚠️Warning
  internal static let warning = L10n.tr("Localizable", "Warning", fallback: "⚠️Warning")
  /// WeChat
  internal static let weChat = L10n.tr("Localizable", "WeChat", fallback: "WeChat")
  /// The WeChat ID has been copied. Go to WeChat to add it.
  internal static let weChatCopied = L10n.tr("Localizable", "WeChatCopied", fallback: "The WeChat ID has been copied. Go to WeChat to add it.")
  /// Week
  internal static let week = L10n.tr("Localizable", "Week", fallback: "Week")
  /// Weekly
  internal static let weekly = L10n.tr("Localizable", "Weekly", fallback: "Weekly")
  /// Week%ld
  internal static func weekNum(_ p1: Int) -> String {
    return L10n.tr("Localizable", "WeekNum", p1, fallback: "Week%ld")
  }
  /// %@, Week: %@
  internal static func weekOfYear(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "WeekOfYear", String(describing: p1), String(describing: p2), fallback: "%@, Week: %@")
  }
  /// An app that helps you better manage your time and improve your productivity.
  internal static let welcomeText = L10n.tr("Localizable", "WelcomeText", fallback: "An app that helps you better manage your time and improve your productivity.")
  /// Welcome To
  internal static let welcomeTo = L10n.tr("Localizable", "WelcomeTo", fallback: "Welcome To")
  /// Work
  internal static let work = L10n.tr("Localizable", "Work", fallback: "Work")
  /// X
  internal static let x = L10n.tr("Localizable", "X", fallback: "X")
  /// Year
  internal static let year = L10n.tr("Localizable", "Year", fallback: "Year")
  /// Yearly
  internal static let yearly = L10n.tr("Localizable", "Yearly", fallback: "Yearly")
  /// Yesterday
  internal static let yesterday = L10n.tr("Localizable", "Yesterday", fallback: "Yesterday")
  /// Haaaaa
  internal static let zaaaaa = L10n.tr("Localizable", "Zaaaaa", fallback: "Haaaaa")
  internal enum AppIsClosed {
    /// App is closed. Create a record for ${eventID}
    internal static let createARecordForEventID = L10n.tr("Localizable", "App is closed. Create a record for ${eventID}", fallback: "App is closed. Create a record for ${eventID}")
  }
  internal enum FreeTrial {
    ///   %@-day free trial  
    internal static func days(_ p1: Any) -> String {
      return L10n.tr("Localizable", "freeTrial.days", String(describing: p1), fallback: "  %@-day free trial  ")
    }
  }
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
