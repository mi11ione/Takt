import Foundation
import SwiftData

@MainActor
final class DeepLinkRouter {
    static let shared = DeepLinkRouter()
    var modelContainer: ModelContainer?

    private init() {}

    func consumePendingAction() async {
        let defaults = UserDefaults.standard
        guard let type = defaults.string(forKey: "pendingActionType"), let name = defaults.string(forKey: "pendingActionName") else { return }
        defaults.removeObject(forKey: "pendingActionType")
        defaults.removeObject(forKey: "pendingActionName")
        switch type {
        case "start_timer":
            await startTimer(named: name)
        case "start_chain":
            await startChain(named: name)
        default:
            break
        }
    }

    private func startTimer(named name: String) async {
        guard let container = modelContainer else { return }
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil })
        let habits = (try? context.fetch(descriptor)) ?? []
        if let habit = habits.first(where: { $0.name.range(of: name, options: [.caseInsensitive, .diacriticInsensitive]) != nil }) {
            await HabitActivityManager.shared.start(habitName: habit.name, durationSeconds: habit.defaultDurationSeconds)
        }
    }

    private func startChain(named name: String) async {
        guard let container = modelContainer else { return }
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Chain>(predicate: #Predicate { $0.archivedAt == nil })
        let chains = (try? context.fetch(descriptor)) ?? []
        _ = chains.first { $0.name.range(of: name, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
        // In‑app navigation to chain start would be handled by a navigation coordinator; omitted here.
    }
}
