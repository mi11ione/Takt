// Live Activity scaffold – target to be added in a separate PR.
import ActivityKit

struct HabitActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
    }

    var title: String
}
