import Foundation

/// Pure functions for streak calculations. Local‑aware via Calendar.
enum StreakCalculator {
    static func currentStreakDays(for dates: [Date], calendar: Calendar = .autoupdatingCurrent) -> Int {
        guard !dates.isEmpty else { return 0 }
        let days = dates.map { calendar.startOfDay(for: $0) }.sorted(by: >)
        var streak = 0
        var cursor = calendar.startOfDay(for: .now)
        for day in days {
            if day == cursor {
                streak += 1
                guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
                cursor = previous
            } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor), day == yesterday {
                // tolerate single day gap if we started late in the day; disabled by default – keep strict
                break
            } else {
                break
            }
        }
        return streak
    }
}
