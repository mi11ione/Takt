import ActivityKit
import Foundation
import OSLog

final class HabitActivityManager {
    static let shared = HabitActivityManager()
    private var activity: Activity<HabitActivityAttributes>?

    // MARK: - Helpers

    static func currentActivity() -> Activity<HabitActivityAttributes>? {
        Activity<HabitActivityAttributes>.activities.first
    }

    // MARK: - Start / Update / End

    func start(habitName: String, durationSeconds: Int) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        if activity != nil { await end() }
        let now = Date()
        let end = now.addingTimeInterval(TimeInterval(max(1, durationSeconds)))
        let attributes = HabitActivityAttributes(title: habitName)
        let state = HabitActivityAttributes.ContentState(
            habitID: nil,
            habitName: habitName,
            emoji: "",
            totalSeconds: durationSeconds,
            startDate: now,
            endDate: end,
            isPaused: false,
            pausedRemainingSeconds: nil,
            lastUpdated: now
        )
        let content = ActivityContent(state: state, staleDate: nil)
        activity = try? Activity.request(attributes: attributes, content: content, pushType: nil, style: .standard)
        Logger.liveActivity.log("start name=\(habitName, privacy: .public) seconds=\(durationSeconds, privacy: .public)")
    }

    func start(habit: Habit, durationSeconds: Int) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        if activity != nil { await end() }
        let now = Date()
        let end = now.addingTimeInterval(TimeInterval(max(1, durationSeconds)))
        let attributes = HabitActivityAttributes(title: habit.name)
        let state = HabitActivityAttributes.ContentState(
            habitID: habit.id,
            habitName: habit.name,
            emoji: habit.emoji,
            totalSeconds: durationSeconds,
            startDate: now,
            endDate: end,
            isPaused: false,
            pausedRemainingSeconds: nil,
            lastUpdated: now
        )
        let content = ActivityContent(state: state, staleDate: nil)
        activity = try? Activity.request(attributes: attributes, content: content, pushType: nil, style: .standard)
        Logger.liveActivity.log("start habit=\(habit.name, privacy: .public) seconds=\(durationSeconds, privacy: .public)")
    }

    func pause(remainingSeconds: Int) async {
        let now = Date()
        let newStateTransform: (HabitActivityAttributes.ContentState) -> HabitActivityAttributes.ContentState = { old in
            HabitActivityAttributes.ContentState(
                habitID: old.habitID,
                habitName: old.habitName,
                emoji: old.emoji,
                totalSeconds: old.totalSeconds,
                startDate: old.startDate,
                endDate: old.endDate,
                isPaused: true,
                pausedRemainingSeconds: max(0, remainingSeconds),
                lastUpdated: now
            )
        }
        if let activity {
            await update(activity: activity, transform: newStateTransform)
        } else if let running = Self.currentActivity() {
            await update(activity: running, transform: newStateTransform)
        }
        Logger.liveActivity.log("pause remaining=\(remainingSeconds, privacy: .public)")
    }

    func resume() async {
        let now = Date()
        let transform: (HabitActivityAttributes.ContentState) -> HabitActivityAttributes.ContentState = { old in
            let remaining = old.pausedRemainingSeconds ?? max(0, Int(old.endDate.timeIntervalSince(now)))
            let newEnd = now.addingTimeInterval(TimeInterval(remaining))
            return HabitActivityAttributes.ContentState(
                habitID: old.habitID,
                habitName: old.habitName,
                emoji: old.emoji,
                totalSeconds: old.totalSeconds,
                startDate: now,
                endDate: newEnd,
                isPaused: false,
                pausedRemainingSeconds: nil,
                lastUpdated: now
            )
        }
        if let activity {
            await update(activity: activity, transform: transform)
        } else if let running = Self.currentActivity() {
            await update(activity: running, transform: transform)
        }
        Logger.liveActivity.log("resume")
    }

    func end() async {
        if let activity {
            let final = HabitActivityAttributes.ContentState(
                habitID: activity.content.state.habitID,
                habitName: activity.content.state.habitName,
                emoji: activity.content.state.emoji,
                totalSeconds: activity.content.state.totalSeconds,
                startDate: activity.content.state.startDate,
                endDate: Date(),
                isPaused: false,
                pausedRemainingSeconds: 0,
                lastUpdated: Date()
            )
            let content = ActivityContent(state: final, staleDate: nil)
            await activity.end(content, dismissalPolicy: .immediate, timestamp: Date())
            self.activity = nil
            Logger.liveActivity.log("end (held activity)")
            return
        }
        if let running = Self.currentActivity() {
            let final = HabitActivityAttributes.ContentState(
                habitID: running.content.state.habitID,
                habitName: running.content.state.habitName,
                emoji: running.content.state.emoji,
                totalSeconds: running.content.state.totalSeconds,
                startDate: running.content.state.startDate,
                endDate: Date(),
                isPaused: false,
                pausedRemainingSeconds: 0,
                lastUpdated: Date()
            )
            let content = ActivityContent(state: final, staleDate: nil)
            await running.end(content, dismissalPolicy: .immediate, timestamp: Date())
            Logger.liveActivity.log("end (system activity)")
        }
    }

    // MARK: - Private

    private func update(activity: Activity<HabitActivityAttributes>, transform: (HabitActivityAttributes.ContentState) -> HabitActivityAttributes.ContentState) async {
        let newState = transform(activity.content.state)
        let content = ActivityContent(state: newState, staleDate: nil)
        await activity.update(content, alertConfiguration: nil, timestamp: Date())
    }
}
