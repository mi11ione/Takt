import ActivityKit
import SwiftUI
import WidgetKit

struct HabitLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HabitActivityAttributes.self) { _ in
            // Minimal placeholder view; replace with your own Live Activity UI.
            Color.clear
        } dynamicIsland: { _ in
            DynamicIsland {
                // Minimal dynamic island regions; replace when designing your UI.
                DynamicIslandExpandedRegion(.center) { Color.clear }
                DynamicIslandExpandedRegion(.bottom) { Color.clear }
            } compactLeading: { Color.clear } compactTrailing: { Color.clear } minimal: { Color.clear }
        }
    }
}
