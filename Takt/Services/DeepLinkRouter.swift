import Foundation
import SwiftData
import OSLog

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

    // MARK: - URL Handling

    func handle(_ url: URL) async {
        guard let container = modelContainer else { return }
        let host = url.host ?? ""
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        func value(_ key: String) -> String? {
            components?.queryItems?.first(where: { $0.name == key })?.value
        }

        Logger.app.log("deeplink url=\(url.absoluteString, privacy: .public)")

        switch host {
        case "start-timer":
            let context = ModelContext(container)
            if let idString = value("id"), let id = UUID(uuidString: idString) {
                let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == id })
                if let habit = try? context.fetch(descriptor).first {
                    TimerStore.shared.start(for: habit, seconds: habit.defaultDurationSeconds)
                }
            } else if let name = value("name") {
                await startTimer(named: name)
            }

        case "complete-and-log":
            let context = ModelContext(container)
            if let idString = value("id"), let id = UUID(uuidString: idString) {
                let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == id })
                if let habit = try? context.fetch(descriptor).first {
                    TimerStore.shared.activeHabit = habit
                    TimerStore.shared.totalSeconds = Int(value("total") ?? "0") ?? habit.defaultDurationSeconds
                    TimerStore.shared.completeAndLog(using: context)
                }
            } else {
                // fall back to current timer
                TimerStore.shared.completeAndLog(using: context)
            }

        case "pause":
            if let remaining = Int(value("remaining") ?? "0") {
                TimerStore.shared.remainingSeconds = remaining
            }
            TimerStore.shared.pause()

        case "resume":
            TimerStore.shared.resume()

        case "cancel":
            TimerStore.shared.cancel()

        case "start-suggested":
            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil })
            let habits = (try? context.fetch(descriptor)) ?? []
            if let rec = RecommendationEngine().recommend(from: habits)?.habit {
                TimerStore.shared.start(for: rec, seconds: rec.defaultDurationSeconds)
            }

        case "nudge-now":
            await NotificationScheduler().scheduleNudgeNow()

        case "start-chain":
            if let name = value("name") { await startChain(named: name) }

        default:
            break
        }
    }
}
