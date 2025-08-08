import Foundation
import SwiftData

/// Service to manage habit templates and suggestions
@MainActor
final class TemplateLibrary {
    static let shared = TemplateLibrary()

    private init() {}

    struct Template: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let emoji: String
        let duration: Int
        let category: String
    }

    /// All available templates
    private let templates: [Template] = [
        // Health & Wellness
        Template(name: "Water Break", emoji: "💧", duration: 30, category: "Health"),
        Template(name: "Desk Stretch", emoji: "🧘", duration: 60, category: "Health"),
        Template(name: "Deep Breathing", emoji: "🌬️", duration: 90, category: "Health"),
        Template(name: "Walk Break", emoji: "🚶", duration: 300, category: "Health"),
        Template(name: "Eye Rest", emoji: "👁️", duration: 120, category: "Health"),
        Template(name: "Posture Check", emoji: "🪑", duration: 30, category: "Health"),

        // Productivity
        Template(name: "Inbox Skim", emoji: "📬", duration: 90, category: "Productivity"),
        Template(name: "Daily Planning", emoji: "📅", duration: 300, category: "Productivity"),
        Template(name: "Code Review", emoji: "💻", duration: 900, category: "Productivity"),
        Template(name: "Quick Tidy", emoji: "🧹", duration: 180, category: "Productivity"),
        Template(name: "Task Review", emoji: "✅", duration: 180, category: "Productivity"),
        Template(name: "Priority Check", emoji: "🎯", duration: 120, category: "Productivity"),

        // Mindfulness
        Template(name: "Meditation", emoji: "🧘‍♀️", duration: 600, category: "Mindfulness"),
        Template(name: "Gratitude", emoji: "🙏", duration: 180, category: "Mindfulness"),
        Template(name: "Journal", emoji: "📝", duration: 300, category: "Mindfulness"),
        Template(name: "Reflection", emoji: "💭", duration: 240, category: "Mindfulness"),
        Template(name: "Mindful Moment", emoji: "🌸", duration: 60, category: "Mindfulness"),

        // Creativity
        Template(name: "Sketch", emoji: "✏️", duration: 600, category: "Creativity"),
        Template(name: "Music Practice", emoji: "🎸", duration: 1800, category: "Creativity"),
        Template(name: "Creative Writing", emoji: "✍️", duration: 900, category: "Creativity"),
        Template(name: "Brainstorm", emoji: "💡", duration: 300, category: "Creativity"),
        Template(name: "Photo Walk", emoji: "📸", duration: 600, category: "Creativity"),

        // Social & Connection
        Template(name: "Call a Friend", emoji: "📞", duration: 600, category: "Social"),
        Template(name: "Send Thanks", emoji: "💌", duration: 180, category: "Social"),
        Template(name: "Check In", emoji: "👋", duration: 120, category: "Social"),

        // Learning
        Template(name: "Read Article", emoji: "📰", duration: 300, category: "Learning"),
        Template(name: "Watch Tutorial", emoji: "🎥", duration: 600, category: "Learning"),
        Template(name: "Practice Language", emoji: "🗣️", duration: 300, category: "Learning"),
        Template(name: "Learn Shortcut", emoji: "⌨️", duration: 180, category: "Learning"),
    ]

    /// Get a random template that is not already in the user's habits
    func getRandomSuggestion(excludingHabits habits: [Habit]) -> Template? {
        let habitNames = Set(habits.map { $0.name.lowercased() })
        let availableTemplates = templates.filter { !habitNames.contains($0.name.lowercased()) }
        return availableTemplates.randomElement()
    }

    /// Get multiple suggestions, ensuring no duplicates
    func getSuggestions(count: Int, excludingHabits habits: [Habit]) -> [Template] {
        let habitNames = Set(habits.map { $0.name.lowercased() })
        let availableTemplates = templates.filter { !habitNames.contains($0.name.lowercased()) }
        return Array(availableTemplates.shuffled().prefix(count))
    }

    /// Convert template to habit
    func createHabit(from template: Template) -> Habit {
        Habit(
            name: template.name,
            emoji: template.emoji,
            defaultDurationSeconds: template.duration
        )
    }
}
