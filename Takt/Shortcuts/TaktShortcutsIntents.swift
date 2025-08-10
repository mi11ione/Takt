import ActivityKit
import AppIntents
import SwiftData
import SwiftUI

// MARK: - Intents

struct StartHabitTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Habit Timer"
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Habit")
    var habit: HabitEntity

    func perform() async throws -> some IntentResult {
        let container = try ModelContainerFactory.makeSharedContainer()
        let model = ModelContext(container)
        let habits = (try? model.fetch(FetchDescriptor<Habit>())) ?? []
        if let target = habits.first(where: { $0.id == habit.id }) {
            await HabitActivityManager.shared.start(habit: target, durationSeconds: target.defaultDurationSeconds)
            return .result()
        }
        return .result()
    }
}

struct CompleteAndLogHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Complete and Log Habit"
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        // End current activity and log an entry
        let activities = Activity<HabitActivityAttributes>.activities
        guard let activity = activities.first else {
            await HabitActivityManager.shared.end()
            return .result()
        }
        let state = activity.content.state
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let context = ModelContext(container)
            // Compute actual elapsed seconds
            let remaining: Int = state.isPaused ? (state.pausedRemainingSeconds ?? 0) : max(0, Int(state.endDate.timeIntervalSince(Date())))
            let elapsed = max(1, state.totalSeconds - remaining)
            let habits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
            if let id = state.habitID {
                if let habit = habits.first(where: { $0.id == id }) {
                    let entry = HabitEntry(performedAt: .now, durationSeconds: elapsed, habit: habit)
                    context.insert(entry)
                    try? context.save()
                }
            } else {
                if let habit = habits.first(where: { $0.name == state.habitName }) {
                    let entry = HabitEntry(performedAt: .now, durationSeconds: elapsed, habit: habit)
                    context.insert(entry)
                    try? context.save()
                }
            }
        } catch {
            // ignore
        }
        await HabitActivityManager.shared.end()
        return .result()
    }
}

struct StartSuggestedHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Suggested Habit"
    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let context = ModelContext(container)
            let habits = (try? context.fetch(FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil }))) ?? []
            if let rec = RecommendationEngine().recommend(from: habits)?.habit {
                await HabitActivityManager.shared.start(habit: rec, durationSeconds: rec.defaultDurationSeconds)
                return .result()
            }
        } catch {}
        return .result()
    }
}

struct NudgeNowIntent: AppIntent {
    static var title: LocalizedStringResource = "Nudge Me"
    static var openAppWhenRun: Bool = false
    func perform() async throws -> some IntentResult {
        await NotificationScheduler().scheduleNudgeNow()
        return .result()
    }
}

struct ToggleHabitFavoriteIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Favorite"
    static var openAppWhenRun: Bool = false
    @Parameter(title: "Habit") var habit: HabitEntity
    func perform() async throws -> some IntentResult {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let context = ModelContext(container)
            let habits = (try? context.fetch(FetchDescriptor<Habit>())) ?? []
            if let target = habits.first(where: { $0.id == habit.id }) {
                target.isFavorite.toggle()
                try? context.save()
                return .result()
            }
        } catch {}
        return .result()
    }
}

struct PauseHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Pause Habit"
    static var openAppWhenRun: Bool = false
    @Parameter(title: "Remaining seconds") var remainingSeconds: Int
    func perform() async throws -> some IntentResult {
        await HabitActivityManager.shared.pause(remainingSeconds: remainingSeconds)
        return .result()
    }
}

struct ResumeHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "Resume Habit"
    static var openAppWhenRun: Bool = false
    func perform() async throws -> some IntentResult {
        await HabitActivityManager.shared.resume()
        return .result()
    }
}

struct EndHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "End Habit"
    static var openAppWhenRun: Bool = false
    func perform() async throws -> some IntentResult {
        await HabitActivityManager.shared.end()
        return .result()
    }
}

// Note: Live Activity/Widgets use deep links; no AppIntents-based SwiftUI buttons here.

struct StartChainIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Chain"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Chain name")
    var name: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        UserDefaults.standard.set("start_chain", forKey: "pendingActionType")
        UserDefaults.standard.set(name, forKey: "pendingActionName")
        return .result(dialog: .init(stringLiteral: "Starting chain \(name)"))
    }
}
