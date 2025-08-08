import ActivityKit
import Foundation

class HabitActivityManager {
    static let shared = HabitActivityManager()
    private var activity: Activity<HabitActivityAttributes>?

    func start(habitName: String, durationSeconds _: Int) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        if activity != nil { await end() }
        let attributes = HabitActivityAttributes(title: habitName)
        let content = ActivityContent(state: HabitActivityAttributes.ContentState(progress: 0), staleDate: nil)
        activity = try? Activity.request(attributes: attributes, content: content, pushType: nil, style: .standard)
    }

    func updateProgress(_ progress: Double) async {
        guard let activity else { return }
        let clamped = max(0, min(1, progress))
        let content = ActivityContent(state: HabitActivityAttributes.ContentState(progress: clamped), staleDate: nil)
        await activity.update(content, alertConfiguration: nil, timestamp: Date())
    }

    func end() async {
        guard let activity else { return }
        let finalContent = ActivityContent(state: HabitActivityAttributes.ContentState(progress: 1.0), staleDate: nil)
        await activity.end(finalContent, dismissalPolicy: .immediate, timestamp: Date())
        self.activity = nil
    }
}
