import Foundation
import UserNotifications

public protocol NotificationScheduling: Sendable {
    func requestAuthorization() async -> Bool
    func scheduleDaypartSuggestions(enabled: Bool) async
    func scheduleConfiguredDayparts(morning: Bool, midday: Bool, afternoon: Bool, evening: Bool, quietStartHour: Int, quietEndHour: Int) async
    func scheduleNudgeNow() async
    func cancelAll()
}

public actor NotificationScheduler: NotificationScheduling {
    public init() {}

    public func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    public func scheduleDaypartSuggestions(enabled: Bool) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [
            "takt.daypart.morning", "takt.daypart.midday", "takt.daypart.afternoon", "takt.daypart.evening",
        ])
        guard enabled else { return }
        let schedule: [(id: String, hour: Int, minute: Int, body: String)] = [
            ("takt.daypart.morning", 9, 0, NSLocalizedString("nudge_morning", comment: "")),
            ("takt.daypart.midday", 12, 30, NSLocalizedString("nudge_midday", comment: "")),
            ("takt.daypart.afternoon", 16, 0, NSLocalizedString("nudge_afternoon", comment: "")),
            ("takt.daypart.evening", 20, 0, NSLocalizedString("nudge_evening", comment: "")),
        ]
        for item in schedule {
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("nudge_title", comment: "")
            content.body = item.body
            content.sound = .default

            var date = DateComponents()
            date.hour = item.hour
            date.minute = item.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            try? await center.add(request)
        }
    }

    public func scheduleConfiguredDayparts(morning: Bool, midday: Bool, afternoon: Bool, evening: Bool, quietStartHour: Int, quietEndHour: Int) async {
        let center = UNUserNotificationCenter.current()
        let ids = ["takt.daypart.morning", "takt.daypart.midday", "takt.daypart.afternoon", "takt.daypart.evening"]
        center.removePendingNotificationRequests(withIdentifiers: ids)

        func withinQuietHours(_ hour: Int) -> Bool {
            if quietStartHour <= quietEndHour { return hour >= quietStartHour && hour < quietEndHour }
            // Quiet hours wrap midnight
            return hour >= quietStartHour || hour < quietEndHour
        }

        let config: [(id: String, hour: Int, minute: Int, bodyKey: String, enabled: Bool)] = [
            ("takt.daypart.morning", 9, 0, "nudge_morning", morning),
            ("takt.daypart.midday", 12, 30, "nudge_midday", midday),
            ("takt.daypart.afternoon", 16, 0, "nudge_afternoon", afternoon),
            ("takt.daypart.evening", 20, 0, "nudge_evening", evening),
        ]

        for item in config where item.enabled && !withinQuietHours(item.hour) {
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("nudge_title", comment: "")
            content.body = NSLocalizedString(item.bodyKey, comment: "")
            content.sound = .default

            var date = DateComponents()
            date.hour = item.hour
            date.minute = item.minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: item.id, content: content, trigger: trigger)
            try? await center.add(request)
        }
    }

    public func scheduleNudgeNow() async {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("nudge_title", comment: "")
        content.body = NSLocalizedString("nudge_now", comment: "")
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try? await center.add(request)
    }

    @MainActor
    public func cancelAll() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
