import ActivityKit
import Foundation

class HabitActivityManager {
    static let shared = HabitActivityManager()
    private var activity: Activity<HabitActivityAttributes>?

    func start(habitName: String, durationSeconds _: Int) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        if activity != nil { await end() }
        let attributes = HabitActivityAttributes(title: habitName)
        let initialState = HabitActivityAttributes.ContentState(progress: 0)
        activity = try? Activity.request(attributes: attributes, contentState: initialState, pushType: nil)
    }

    func updateProgress(_ progress: Double) async {
        guard let activity else { return }
        let state = HabitActivityAttributes.ContentState(progress: max(0, min(1, progress)))
        await activity.update(using: state)
    }

    func end() async {
        guard let activity else { return }
        await activity.end(dismissalPolicy: .immediate)
        self.activity = nil
    }
}
