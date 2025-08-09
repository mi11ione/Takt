// Live Activity attributes for Habit timers. UI configuration is provided in the Widget Extension.
import ActivityKit
import Foundation

struct HabitActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Identity
        var habitID: UUID?
        var habitName: String
        var emoji: String

        // Timing
        var totalSeconds: Int
        var startDate: Date
        var endDate: Date

        // Control state
        var isPaused: Bool
        var pausedRemainingSeconds: Int?

        // Bookkeeping
        var lastUpdated: Date
    }

    var title: String
}

