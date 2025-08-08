import Foundation
import SwiftData

/// Lightweight on‑device recommendations for next‑best habit.
struct RecommendationEngine {
    struct Recommendation: Equatable { let habit: Habit; let score: Double }

    func recommend(from habits: [Habit], now: Date = .now) -> Recommendation? {
        let calendar = Calendar.autoupdatingCurrent
        guard !habits.isEmpty else { return nil }
        let hour = calendar.component(.hour, from: now)

        func score(_ habit: Habit) -> Double {
            var s: Double = 0
            // Favor favorites
            if habit.isFavorite { s += 2 }
            // Recency: penalize if already logged in past 2 hours
            if let last = habit.entries.map(\ .performedAt).max(), let diff = calendar.dateComponents([.hour], from: last, to: now).hour, diff < 2 {
                s -= 3
            }
            // Time of day boost: if default duration <= 60 and morning hours
            if hour >= 7, hour <= 10, habit.defaultDurationSeconds <= 60 { s += 1 }
            // Gentle randomness to break ties
            s += Double.random(in: 0 ... 0.3)
            return s
        }

        let best = habits.max(by: { score($0) < score($1) })
        if let best { return .init(habit: best, score: score(best)) }
        return nil
    }
}
