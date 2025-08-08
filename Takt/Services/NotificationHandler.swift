import Foundation
import SwiftData
import UserNotifications

final class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationHandler()
    var container: ModelContainer?

    override private init() { super.init() }

    func registerCategories() {
        let logAction = UNNotificationAction(identifier: "LOG_QUICK", title: NSLocalizedString("nudge_action_log", comment: ""), options: [.authenticationRequired])
        let timerAction = UNNotificationAction(identifier: "START_TIMER", title: NSLocalizedString("nudge_action_timer", comment: ""), options: [.foreground])
        let category = UNNotificationCategory(identifier: "TAKT_DAYPART", actions: [logAction, timerAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        switch response.actionIdentifier {
        case "LOG_QUICK":
            await logFavoriteHabit()
        default:
            break
        }
    }

    private func logFavoriteHabit() async {
        guard let container else { return }
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil && $0.isFavorite == true }, sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        if let habit = try? context.fetch(descriptor).first {
            let entry = HabitEntry(performedAt: .now, durationSeconds: habit.defaultDurationSeconds, habit: habit)
            context.insert(entry)
            try? context.save()
        }
    }
}
