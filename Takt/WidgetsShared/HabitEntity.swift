import AppIntents
import SwiftData

// AppEntity for Widgets/Intents. Include this file in both App and Widget Extension targets.
struct HabitEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Habit"
    static var defaultQuery = HabitQuery()

    let id: UUID
    let name: String
    let emoji: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: .init(stringLiteral: name), subtitle: .init(stringLiteral: emoji))
    }
}

struct HabitQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [HabitEntity] {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { identifiers.contains($0.id) })
            let habits = (try? context.fetch(descriptor)) ?? []
            return habits.map { HabitEntity(id: $0.id, name: $0.name, emoji: $0.emoji) }
        } catch { return [] }
    }

    func suggestedEntities() async throws -> [HabitEntity] {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil })
            let habits = (try? context.fetch(descriptor)) ?? []
            return Array(habits.prefix(5)).map { HabitEntity(id: $0.id, name: $0.name, emoji: $0.emoji) }
        } catch { return [] }
    }
}


