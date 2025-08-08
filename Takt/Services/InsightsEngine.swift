import Foundation
import SwiftData

struct InsightsEngine {
    let calendar: Calendar = .autoupdatingCurrent

    func weeklyEntryCount(entries: [HabitEntry]) -> Int {
        entries.filter { calendar.isDate($0.performedAt, equalTo: .now, toGranularity: .weekOfYear) }.count
    }

    func mostConsistentHour(entries: [HabitEntry]) -> Int? {
        let thisWeek = entries.filter { calendar.isDate($0.performedAt, equalTo: .now, toGranularity: .weekOfYear) }
        guard !thisWeek.isEmpty else { return nil }
        let bucketed = Dictionary(grouping: thisWeek) { calendar.component(.hour, from: $0.performedAt) }
        return bucketed.max(by: { $0.value.count < $1.value.count })?.key
    }

    func longestStreakDays(for habit: Habit) -> Int {
        let dates = habit.entries.map(\ .performedAt)
        // Compute longest consecutive streak over all time
        let days = Set(dates.map { calendar.startOfDay(for: $0) })
        guard !days.isEmpty else { return 0 }
        let sorted = days.sorted()
        var best = 1
        var current = 1
        for i in 1 ..< sorted.count {
            if let prev = calendar.date(byAdding: .day, value: 1, to: sorted[i - 1]), prev == sorted[i] {
                current += 1
                best = max(best, current)
            } else {
                current = 1
            }
        }
        return best
    }
}
