import Foundation
import SwiftData

/// SwiftData model schema for Takt.
/// Migration plan:
/// - Start at Schema v1 with `Habit` and `HabitEntry`.
/// - Future: add `Chain` entity; use lightweight migrations where possible.
/// - Keep models domain‑pure; no business logic here.
enum DataModelSchema {
    static let current = Schema([
        Habit.self,
        HabitEntry.self,
    ])
}

@Model
final class Habit {
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var createdAt: Date
    var isFavorite: Bool

    @Relationship(deleteRule: .cascade, inverse: \HabitEntry.habit)
    var entries: [HabitEntry]

    init(id: UUID = UUID(), name: String, emoji: String, createdAt: Date = .now, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        entries = []
    }
}

@Model
final class HabitEntry {
    @Attribute(.unique) var id: UUID
    var performedAt: Date
    var durationSeconds: Int

    @Relationship(deleteRule: .noAction) var habit: Habit?

    init(id: UUID = UUID(), performedAt: Date = .now, durationSeconds: Int = 60, habit: Habit? = nil) {
        self.id = id
        self.performedAt = performedAt
        self.durationSeconds = durationSeconds
        self.habit = habit
    }
}
