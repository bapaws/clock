// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
    /// About
    static let about = L10n.tr("Localizable", "About", fallback: "About")
    /// Adjacent Records
    static let adjacentRecords = L10n.tr("Localizable", "AdjacentRecords", fallback: "Adjacent Records")
    /// Afternoon Tea
    static let afternoonTea = L10n.tr("Localizable", "AfternoonTea", fallback: "Afternoon Tea")
    /// All
    static let all = L10n.tr("Localizable", "All", fallback: "All")
    /// AM
    static let am = L10n.tr("Localizable", "AM", fallback: "AM")
    ///  and
    static let and = L10n.tr("Localizable", "And", fallback: " and ")
    /// App Did Close
    static let appDidClose = L10n.tr("Localizable", "AppDidClose", fallback: "App Did Close")
    /// App Did Open
    static let appDidOpen = L10n.tr("Localizable", "AppDidOpen", fallback: "App Did Open")
    /// Appearance
    static let appearance = L10n.tr("Localizable", "Appearance", fallback: "Appearance")
    /// App Icon
    static let appIcon = L10n.tr("Localizable", "AppIcon", fallback: "App Icon")
    /// Localizable.strings
    ///   Counter
    ///
    ///   Created by 张敏超 on 2024/3/3.
    static let appName = L10n.tr("Localizable", "AppName", fallback: "Hours")
    /// App Screen Time
    static let appScreenTime = L10n.tr("Localizable", "AppScreenTime", fallback: "App Screen Time")
    /// Auto-record your screen time. Just set up the Shortcuts app on iOS to listen for our app's open and close events. It's that simple!
    static let appScreenTimeDesc = L10n.tr("Localizable", "AppScreenTimeDesc", fallback: "Auto-record your screen time. Just set up the Shortcuts app on iOS to listen for our app's open and close events. It's that simple!")
    /// Record App Screen Time
    static let appScreenTimeTitle = L10n.tr("Localizable", "AppScreenTimeTitle", fallback: "Record App Screen Time")
    /// Archive
    static let archive = L10n.tr("Localizable", "Archive", fallback: "Archive")
    /// Archived
    static let archived = L10n.tr("Localizable", "Archived", fallback: "Archived")
    /// Archived At: %@
    static func archivedAt(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ArchivedAt", String(describing: p1), fallback: "Archived At: %@")
    }

    /// Auto Merge Adjacent Records
    static let autoMergeAdjacentRecords = L10n.tr("Localizable", "AutoMergeAdjacentRecords", fallback: "Auto Merge Adjacent Records")
    /// Auto-Record Setup Guide
    static let autoRecordSetupGuide = L10n.tr("Localizable", "AutoRecordSetupGuide", fallback: "Auto-Record Setup Guide")
    /// Background Sound
    static let backgroundSound = L10n.tr("Localizable", "BackgroundSound", fallback: "Background Sound")
    /// Break
    static let `break` = L10n.tr("Localizable", "Break", fallback: "Break")
    /// Break has finished，Keep fighting!💪💪💪
    static let breakCompletedNotification = L10n.tr("Localizable", "BreakCompletedNotification", fallback: "Break has finished，Keep fighting!💪💪💪")
    /// Please allow Hours access to your calendar so that you can see your time consumption in Apple Calendar.
    static let calendarDesc = L10n.tr("Localizable", "CalendarDesc", fallback: "Please allow Hours access to your calendar so that you can see your time consumption in Apple Calendar.")
    /// Hours cannot access Calendar and can be turned on in settings later.
    static let calendarNotAccess = L10n.tr("Localizable", "CalendarNotAccess", fallback: "Hours cannot access Calendar and can be turned on in settings later.")
    /// Use with Apple Calendar
    static let calendarTitle = L10n.tr("Localizable", "CalendarTitle", fallback: "Use with Apple Calendar")
    /// Cancel
    static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Cancel")
    /// Card
    static let card = L10n.tr("Localizable", "Card", fallback: "Card")
    /// Category
    static let category = L10n.tr("Localizable", "Category", fallback: "Category")
    /// Category Name
    static let categoryName = L10n.tr("Localizable", "CategoryName", fallback: "Category Name")
    /// Classic
    static let classic = L10n.tr("Localizable", "Classic", fallback: "Classic")
    /// Cleaning
    static let cleaning = L10n.tr("Localizable", "Cleaning", fallback: "Cleaning")
    /// Clock
    static let clock = L10n.tr("Localizable", "Clock", fallback: "Clock")
    /// Coding
    static let coding = L10n.tr("Localizable", "Coding", fallback: "Coding")
    /// Collapse
    static let collapse = L10n.tr("Localizable", "Collapse", fallback: "Collapse")
    /// Color Themes
    static let colorThemes = L10n.tr("Localizable", "ColorThemes", fallback: "Color Themes")
    /// Congratulations! 👏👏👏
    static let congratulations = L10n.tr("Localizable", "Congratulations", fallback: "Congratulations! 👏👏👏")
    /// Continue
    static let `continue` = L10n.tr("Localizable", "Continue", fallback: "Continue")
    /// Cooking
    static let cooking = L10n.tr("Localizable", "Cooking", fallback: "Cooking")
    /// Daily Input
    static let dailyInput = L10n.tr("Localizable", "DailyInput", fallback: "Daily Input")
    /// Dark
    static let dark = L10n.tr("Localizable", "Dark", fallback: "Dark")
    /// Classic Dark
    static let darkClassic = L10n.tr("Localizable", "DarkClassic", fallback: "Classic Dark")
    /// Dark Mode
    static let darkMode = L10n.tr("Localizable", "DarkMode", fallback: "Dark Mode")
    /// Day
    static let day = L10n.tr("Localizable", "Day", fallback: "Day")
    /// d
    static let days = L10n.tr("Localizable", "Days", fallback: "d")
    /// Default
    static let `default` = L10n.tr("Localizable", "Default", fallback: "Default")
    /// Delete
    static let delete = L10n.tr("Localizable", "Delete", fallback: "Delete")
    /// Are you sure you want to delete "%@"?
    ///  All records of "%@" will also be deleted together.
    static func deleteEventWarning(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "DeleteEventWarning", String(describing: p1), String(describing: p2), fallback: "Are you sure you want to delete \"%@\"? \n All records of \"%@\" will also be deleted together.")
    }

    /// Dota2
    static let dota2 = L10n.tr("Localizable", "Dota2", fallback: "Dota2")
    /// Drip
    static let drip = L10n.tr("Localizable", "Drip", fallback: "Drip")
    /// Duration
    static let duration = L10n.tr("Localizable", "Duration", fallback: "Duration")
    /// Edit
    static let edit = L10n.tr("Localizable", "Edit", fallback: "Edit")
    /// Edit Event
    static let editEvent = L10n.tr("Localizable", "EditEvent", fallback: "Edit Event")
    /// Edit Record
    static let editRecord = L10n.tr("Localizable", "EditRecord", fallback: "Edit Record")
    /// Email
    static let email = L10n.tr("Localizable", "Email", fallback: "Email")
    /// Email address has been copied.
    static let emailCopied = L10n.tr("Localizable", "EmailCopied", fallback: "Email address has been copied.")
    /// <p>ℹ️Info：</p><ul><li>System Name: %@</li><li>System Version: %@</li><li>Model: %@</li><li>App Version: %@</li></ul><p>Issues：</p><p></p>
    static func emailMessageBody(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any) -> String {
        return L10n.tr("Localizable", "EmailMessageBody", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), fallback: "<p>ℹ️Info：</p><ul><li>System Name: %@</li><li>System Version: %@</li><li>Model: %@</li><li>App Version: %@</li></ul><p>Issues：</p><p></p>")
    }

    /// Emoji
    static let emoji = L10n.tr("Localizable", "Emoji", fallback: "Emoji")
    /// End Time
    static let endTime = L10n.tr("Localizable", "EndTime", fallback: "End Time")
    /// English
    static let english = L10n.tr("Localizable", "English", fallback: "English")
    /// Entertainment
    static let entertainment = L10n.tr("Localizable", "Entertainment", fallback: "Entertainment")
    /// Event
    static let event = L10n.tr("Localizable", "Event", fallback: "Event")
    /// Event Name
    static let eventName = L10n.tr("Localizable", "EventName", fallback: "Event Name")
    /// Events
    static let events = L10n.tr("Localizable", "Events", fallback: "Events")
    /// Exam
    static let exam = L10n.tr("Localizable", "Exam", fallback: "Exam")
    /// Expand
    static let expand = L10n.tr("Localizable", "Expand", fallback: "Expand")
    /// Feedback
    static let feedback = L10n.tr("Localizable", "Feedback", fallback: "Feedback")
    /// Finish
    static let finish = L10n.tr("Localizable", "Finish", fallback: "Finish")
    /// Congratulations! Keep going!👏👏👏
    static let focusCompletedNotification = L10n.tr("Localizable", "FocusCompletedNotification", fallback: "Congratulations! Keep going!👏👏👏")
    /// Focus Duration
    static let focusDuration = L10n.tr("Localizable", "FocusDuration", fallback: "Focus Duration")
    /// Game
    static let game = L10n.tr("Localizable", "Game", fallback: "Game")
    /// Genshin
    static let genshin = L10n.tr("Localizable", "Genshin", fallback: "Genshin")
    /// Get Pro
    static let getPro = L10n.tr("Localizable", "GetPro", fallback: "Get Pro")
    /// HaHa
    static let haHa = L10n.tr("Localizable", "HaHa", fallback: "HaHa")
    /// Health
    static let health = L10n.tr("Localizable", "Health", fallback: "Health")
    /// Auto Sync Sleep
    static let healthAutoSyncSleep = L10n.tr("Localizable", "HealthAutoSyncSleep", fallback: "Auto Sync Sleep")
    /// Auto Sync Workout
    static let healthAutoSyncWorkout = L10n.tr("Localizable", "HealthAutoSyncWorkout", fallback: "Auto Sync Workout")
    /// Please allow Hours access to your Health, So that your sleep and workout records can be automatically synchronized.
    static let healthDesc = L10n.tr("Localizable", "HealthDesc", fallback: "Please allow Hours access to your Health, So that your sleep and workout records can be automatically synchronized.")
    /// Hours cannot access Health and can be turned on in settings later.
    static let healthNotAccess = L10n.tr("Localizable", "HealthNotAccess", fallback: "Hours cannot access Health and can be turned on in settings later.")
    /// Record Sleep & Workout
    static let healthTitle = L10n.tr("Localizable", "HealthTitle", fallback: "Record Sleep & Workout")
    /// Heat Map
    static let heatMap = L10n.tr("Localizable", "HeatMap", fallback: "Heat Map")
    /// h
    static let hours = L10n.tr("Localizable", "Hours", fallback: "h")
    /// Housework
    static let housework = L10n.tr("Localizable", "Housework", fallback: "Housework")
    /// Icon
    static let icon = L10n.tr("Localizable", "Icon", fallback: "Icon")
    /// Interval
    static let interval = L10n.tr("Localizable", "Interval", fallback: "Interval")
    /// Last 7 Days
    static let last7Days = L10n.tr("Localizable", "Last7Days", fallback: "Last 7 Days")
    /// Leave
    static let leave = L10n.tr("Localizable", "Leave", fallback: "Leave")
    /// Life
    static let life = L10n.tr("Localizable", "Life", fallback: "Life")
    /// Light
    static let light = L10n.tr("Localizable", "Light", fallback: "Light")
    /// Classic Light
    static let lightClassic = L10n.tr("Localizable", "LightClassic", fallback: "Classic Light")
    /// Light Mode
    static let lightMode = L10n.tr("Localizable", "LightMode", fallback: "Light Mode")
    /// Long Break Duration
    static let longBreakDuration = L10n.tr("Localizable", "LongBreakDuration", fallback: "Long Break Duration")
    /// Math
    static let math = L10n.tr("Localizable", "Math", fallback: "Math")
    /// Maximum Recorded Time
    static let maximumRecordedTime = L10n.tr("Localizable", "MaximumRecordedTime", fallback: "Maximum Recorded Time")
    /// Midday Nap
    static let middayNap = L10n.tr("Localizable", "MiddayNap", fallback: "Midday Nap")
    /// Minimum Recorded Time
    static let minimumRecordedTime = L10n.tr("Localizable", "MinimumRecordedTime", fallback: "Minimum Recorded Time")
    /// min
    static let minutes = L10n.tr("Localizable", "Minutes", fallback: "min")
    /// Use Device Setting
    static let modeAuto = L10n.tr("Localizable", "ModeAuto", fallback: "Use Device Setting")
    /// Month
    static let month = L10n.tr("Localizable", "Month", fallback: "Month")
    /// Monthly
    static let monthly = L10n.tr("Localizable", "Monthly", fallback: "Monthly")
    /// Music
    static let music = L10n.tr("Localizable", "Music", fallback: "Music")
    /// Mute
    static let mute = L10n.tr("Localizable", "Mute", fallback: "Mute")
    /// Mokugyo
    static let muyu = L10n.tr("Localizable", "Muyu", fallback: "Mokugyo")
    /// New Category
    static let newCategory = L10n.tr("Localizable", "NewCategory", fallback: "New Category")
    /// New Event
    static let newEvent = L10n.tr("Localizable", "NewEvent", fallback: "New Event")
    /// New Record
    static let newRecord = L10n.tr("Localizable", "NewRecord", fallback: "New Record")
    /// Note
    static let note = L10n.tr("Localizable", "Note", fallback: "Note")
    /// Onboarding
    static let onboarding = L10n.tr("Localizable", "Onboarding", fallback: "Onboarding")
    /// Orange
    static let orange = L10n.tr("Localizable", "Orange", fallback: "Orange")
    /// Other
    static let other = L10n.tr("Localizable", "Other", fallback: "Other")
    /// Overall
    static let overall = L10n.tr("Localizable", "Overall", fallback: "Overall")
    /// Pendulum
    static let pendulum = L10n.tr("Localizable", "Pendulum", fallback: "Pendulum")
    /// Personal Grooming
    static let personalGrooming = L10n.tr("Localizable", "PersonalGrooming", fallback: "Personal Grooming")
    /// Pink
    static let pink = L10n.tr("Localizable", "Pink", fallback: "Pink")
    /// Add records via timer or pomodoro.
    static let playButtonTipMessage = L10n.tr("Localizable", "PlayButtonTipMessage", fallback: "Add records via timer or pomodoro.")
    /// Start a timer or pomodoro
    static let playButtonTipTitle = L10n.tr("Localizable", "PlayButtonTipTitle", fallback: "Start a timer or pomodoro")
    /// Please enter...
    static let pleaseEnter = L10n.tr("Localizable", "PleaseEnter", fallback: "Please enter...")
    /// Please select...
    static let pleaseSelect = L10n.tr("Localizable", "PleaseSelect", fallback: "Please select...")
    /// PM
    static let pm = L10n.tr("Localizable", "PM", fallback: "PM")
    /// Pomodoro
    static let pomodoro = L10n.tr("Localizable", "Pomodoro", fallback: "Pomodoro")
    /// Hours Premium
    static let premium = L10n.tr("Localizable", "Premium", fallback: "Hours Premium")
    /// Privacy Policy
    static let privacy = L10n.tr("Localizable", "Privacy", fallback: "Privacy Policy")
    /// Unlock statistics features
    static let proInfo1 = L10n.tr("Localizable", "ProInfo1", fallback: "Unlock statistics features")
    /// Remove in-app ads
    static let proInfo2 = L10n.tr("Localizable", "ProInfo2", fallback: "Remove in-app ads")
    /// More personalization
    static let proInfo3 = L10n.tr("Localizable", "ProInfo3", fallback: "More personalization")
    /// More surprise features in the future.
    static let proInfo4 = L10n.tr("Localizable", "ProInfo4", fallback: "More surprise features in the future.")
    /// Pro Membership
    static let proMembership = L10n.tr("Localizable", "ProMembership", fallback: "Pro Membership")
    /// Purple
    static let purple = L10n.tr("Localizable", "Purple", fallback: "Purple")
    /// Rate Our App
    static let rate = L10n.tr("Localizable", "Rate", fallback: "Rate Our App")
    /// Reading
    static let reading = L10n.tr("Localizable", "Reading", fallback: "Reading")
    /// Recent
    static let recent = L10n.tr("Localizable", "Recent", fallback: "Recent")
    /// Record Count
    static let recordCount = L10n.tr("Localizable", "RecordCount", fallback: "Record Count")
    /// Records
    static let records = L10n.tr("Localizable", "Records", fallback: "Records")
    /// RED
    static let redBook = L10n.tr("Localizable", "RedBook", fallback: "RED")
    /// Restore
    static let restore = L10n.tr("Localizable", "Restore", fallback: "Restore")
    /// Running
    static let running = L10n.tr("Localizable", "Running", fallback: "Running")
    /// SALE
    static let sale = L10n.tr("Localizable", "Sale", fallback: "SALE")
    /// Save
    static let save = L10n.tr("Localizable", "Save", fallback: "Save")
    /// Second Hand
    static let secondHand = L10n.tr("Localizable", "SecondHand", fallback: "Second Hand")
    /// s
    static let seconds = L10n.tr("Localizable", "Seconds", fallback: "s")
    /// Select Category
    static let selectCategory = L10n.tr("Localizable", "SelectCategory", fallback: "Select Category")
    /// Select Emoji
    static let selectEmoji = L10n.tr("Localizable", "SelectEmoji", fallback: "Select Emoji")
    /// Select Event
    static let selectEvent = L10n.tr("Localizable", "SelectEvent", fallback: "Select Event")
    /// Send an email
    static let sendEmail = L10n.tr("Localizable", "SendEmail", fallback: "Send an email")
    /// Settings
    static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
    /// Set up later
    static let setupLater = L10n.tr("Localizable", "SetupLater", fallback: "Set up later")
    /// Shopping
    static let shopping = L10n.tr("Localizable", "Shopping", fallback: "Shopping")
    /// Break
    static let shortBreakDuration = L10n.tr("Localizable", "ShortBreakDuration", fallback: "Break")
    /// Show All
    static let showAll = L10n.tr("Localizable", "ShowAll", fallback: "Show All")
    /// Always Display Hours
    static let showHour = L10n.tr("Localizable", "ShowHour", fallback: "Always Display Hours")
    /// Display Seconds
    static let showSecond = L10n.tr("Localizable", "ShowSecond", fallback: "Display Seconds")
    /// Sleep
    static let sleep = L10n.tr("Localizable", "Sleep", fallback: "Sleep")
    /// Let time hold more value.
    static let slogan = L10n.tr("Localizable", "Slogan", fallback: "Let time hold more value.")
    /// Sound
    static let sound = L10n.tr("Localizable", "Sound", fallback: "Sound")
    /// Sports
    static let sports = L10n.tr("Localizable", "Sports", fallback: "Sports")
    /// Start Break
    static let startBreak = L10n.tr("Localizable", "StartBreak", fallback: "Start Break")
    /// Start Pomodoro
    static let startPomodoro = L10n.tr("Localizable", "StartPomodoro", fallback: "Start Pomodoro")
    /// Start Time
    static let startTime = L10n.tr("Localizable", "StartTime", fallback: "Start Time")
    /// Start Timer
    static let startTimer = L10n.tr("Localizable", "StartTimer", fallback: "Start Timer")
    /// Statistics
    static let statistics = L10n.tr("Localizable", "Statistics", fallback: "Statistics")
    /// Unlock deep insights into time management, customize your daily productivity, and achieve your goals with our Statistics Pro – making every moment count.
    static let statisticsDesc = L10n.tr("Localizable", "StatisticsDesc", fallback: "Unlock deep insights into time management, customize your daily productivity, and achieve your goals with our Statistics Pro – making every moment count.")
    /// Statistics Pro
    static let statisticsTitle = L10n.tr("Localizable", "StatisticsTitle", fallback: "Statistics Pro")
    /// Study
    static let study = L10n.tr("Localizable", "Study", fallback: "Study")
    /// After confirming the purchase, your Apple account will be charged, and the subscription will be automatically renewed if you purchase a monthly or yearly subscription, your Apple account will be charged 24 hours before the expiration date, and the subscription cycle will be postponed to the next subscription cycle after the successful deduction of the charge.
    /// If you want to cancel the automatic subscription, please turn off the auto-renewal function 24 hours before the end of the current subscription cycle. You can cancel your subscription by going to "Settings" --> click "Apple ID", click "Subscribe" and select "Desktop Clock" to unsubscribe.
    /// If the recharge does not arrive, please send your Apple ID and debit voucher to dev@bapaws.com.
    /// Pro member ad-free service temporarily includes the removal of app opening screen ads, banner ads.
    /// Pro member service is an online commodity and virtual commodity, once opened can not be refunded, thank you for your understanding and support.
    static let subscriptionWarning = L10n.tr("Localizable", "subscriptionWarning", fallback: "After confirming the purchase, your Apple account will be charged, and the subscription will be automatically renewed if you purchase a monthly or yearly subscription, your Apple account will be charged 24 hours before the expiration date, and the subscription cycle will be postponed to the next subscription cycle after the successful deduction of the charge.\nIf you want to cancel the automatic subscription, please turn off the auto-renewal function 24 hours before the end of the current subscription cycle. You can cancel your subscription by going to \"Settings\" --> click \"Apple ID\", click \"Subscribe\" and select \"Desktop Clock\" to unsubscribe.\nIf the recharge does not arrive, please send your Apple ID and debit voucher to dev@bapaws.com.\nPro member ad-free service temporarily includes the removal of app opening screen ads, banner ads.\nPro member service is an online commodity and virtual commodity, once opened can not be refunded, thank you for your understanding and support.")
    /// Summary
    static let summary = L10n.tr("Localizable", "Summary", fallback: "Summary")
    /// Swimming
    static let swimming = L10n.tr("Localizable", "Swimming", fallback: "Swimming")
    /// Switch
    static let `switch` = L10n.tr("Localizable", "Switch", fallback: "Switch")
    /// Sync records to Calendar
    static let syncRecordsToCalendar = L10n.tr("Localizable", "SyncRecordsToCalendar", fallback: "Sync records to Calendar")
    /// Terms of Use
    static let terms = L10n.tr("Localizable", "Terms", fallback: "Terms of Use")
    /// This Month, %@
    static func thisMonth(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ThisMonth", String(describing: p1), fallback: "This Month, %@")
    }

    /// This Week, %@
    static func thisWeek(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ThisWeek", String(describing: p1), fallback: "This Week, %@")
    }

    /// This Year, %@
    static func thisYear(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ThisYear", String(describing: p1), fallback: "This Year, %@")
    }

    /// Tick
    static let tick = L10n.tr("Localizable", "Tick", fallback: "Tick")
    /// Time
    static let time = L10n.tr("Localizable", "Time", fallback: "Time")
    /// Time Distribution
    static let timeDistribution = L10n.tr("Localizable", "TimeDistribution", fallback: "Time Distribution")
    /// Time Format
    static let timeFormat = L10n.tr("Localizable", "TimeFormat", fallback: "Time Format")
    /// Time Invest
    static let timeInvest = L10n.tr("Localizable", "TimeInvest", fallback: "Time Invest")
    /// Timer
    static let timer = L10n.tr("Localizable", "Timer", fallback: "Timer")
    /// Timing Mode
    static let timingMode = L10n.tr("Localizable", "TimingMode", fallback: "Timing Mode")
    /// Today
    static let today = L10n.tr("Localizable", "Today", fallback: "Today")
    /// Total
    static let total = L10n.tr("Localizable", "Total", fallback: "Total")
    /// Total Invest
    static let totalInvest = L10n.tr("Localizable", "TotalInvest", fallback: "Total Invest")
    /// Travel
    static let travel = L10n.tr("Localizable", "Travel", fallback: "Travel")
    /// Try Free
    static let tryFree = L10n.tr("Localizable", "TryFree", fallback: "Try Free")
    /// Unarchive
    static let unarchive = L10n.tr("Localizable", "Unarchive", fallback: "Unarchive")
    /// Unlock all premium features.
    static let unlockPro = L10n.tr("Localizable", "UnlockPro", fallback: "Unlock all premium features.")
    /// Upgrade
    static let upgrade = L10n.tr("Localizable", "Upgrade", fallback: "Upgrade")
    /// Video
    static let video = L10n.tr("Localizable", "Video", fallback: "Video")
    /// ⚠️Warning
    static let warning = L10n.tr("Localizable", "Warning", fallback: "⚠️Warning")
    /// WeChat
    static let weChat = L10n.tr("Localizable", "WeChat", fallback: "WeChat")
    /// The WeChat ID has been copied. Go to WeChat to add it.
    static let weChatCopied = L10n.tr("Localizable", "WeChatCopied", fallback: "The WeChat ID has been copied. Go to WeChat to add it.")
    /// Week
    static let week = L10n.tr("Localizable", "Week", fallback: "Week")
    /// Weekly
    static let weekly = L10n.tr("Localizable", "Weekly", fallback: "Weekly")
    /// Week%ld
    static func weekNum(_ p1: Int) -> String {
        return L10n.tr("Localizable", "WeekNum", p1, fallback: "Week%ld")
    }

    /// %@, Week: %@
    static func weekOfYear(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "WeekOfYear", String(describing: p1), String(describing: p2), fallback: "%@, Week: %@")
    }

    /// An app that helps you better manage your time and improve your productivity.
    static let welcomeText = L10n.tr("Localizable", "WelcomeText", fallback: "An app that helps you better manage your time and improve your productivity.")
    /// Welcome To
    static let welcomeTo = L10n.tr("Localizable", "WelcomeTo", fallback: "Welcome To")
    /// Work
    static let work = L10n.tr("Localizable", "Work", fallback: "Work")
    /// X
    static let x = L10n.tr("Localizable", "X", fallback: "X")
    /// Year
    static let year = L10n.tr("Localizable", "Year", fallback: "Year")
    /// Yearly
    static let yearly = L10n.tr("Localizable", "Yearly", fallback: "Yearly")
    /// Yesterday
    static let yesterday = L10n.tr("Localizable", "Yesterday", fallback: "Yesterday")
    enum AppIsClosed {
        /// App is closed. Create a record for ${eventID}
        static let createARecordForEventID = L10n.tr("Localizable", "App is closed. Create a record for ${eventID}", fallback: "App is closed. Create a record for ${eventID}")
    }

    enum FreeTrial {
        ///   %@-day free trial
        static func days(_ p1: Any) -> String {
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
