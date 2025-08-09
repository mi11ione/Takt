// Live Activity UI – include this file in the Widget Extension target membership.
import WidgetKit
import SwiftUI
import ActivityKit
import AppIntents

@available(iOS 16.1, *)
struct HabitLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HabitActivityAttributes.self) { context in
            // Lock Screen presentation
            VStack(spacing: 8) {
                HStack {
                    Text(context.state.emoji).font(.title2)
                    Text(context.state.habitName).font(.headline)
                    Spacer()
                    RemainingView(context: context)
                }
                ProgressView(value: progress(context))
                    .progressViewStyle(.linear)
                HStack(spacing: 12) {
                    if context.state.isPaused {
                        Link(destination: URL(string: "takt://resume")!) { Label("Resume", systemImage: "play.fill") }
                            .buttonStyle(.borderedProminent)
                    } else {
                        Link(destination: URL(string: "takt://pause?remaining=\(remainingSeconds(context))")!) { Label("Pause", systemImage: "pause.fill") }
                            .buttonStyle(.borderedProminent)
                    }
                    Link(destination: URL(string: "takt://complete-and-log")!) { Label("Done", systemImage: "checkmark") }
                        .buttonStyle(.bordered)
                }
            }
            .padding(12)
            .containerBackground(for: .widget) {
                Color("Card")
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 6) {
                        Text(context.state.habitName).font(.headline)
                        ProgressView(value: progress(context)) {
                            HStack(spacing: 6) {
                                Text(context.state.emoji)
                                RemainingView(context: context).monospacedDigit()
                            }
                        }
                        .progressViewStyle(.linear)
                    }
                    .padding(.horizontal, 8)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 12) {
                        if context.state.isPaused {
                            Link(destination: URL(string: "takt://resume")!) { Label("Resume", systemImage: "play.fill") }
                                .buttonStyle(.borderedProminent)
                        } else {
                            Link(destination: URL(string: "takt://pause?remaining=\(remainingSeconds(context))")!) { Label("Pause", systemImage: "pause.fill") }
                                .buttonStyle(.borderedProminent)
                        }
                        Link(destination: URL(string: "takt://complete-and-log")!) { Label("Done", systemImage: "checkmark") }
                            .buttonStyle(.bordered)
                    }
                }
            } compactLeading: {
                Text(context.state.emoji)
            } compactTrailing: {
                RemainingView(context: context).font(.caption2).monospacedDigit()
            } minimal: {
                Text(context.state.emoji)
            }
        }
    }
}

@available(iOS 16.1, *)
private func remainingSeconds(_ context: ActivityViewContext<HabitActivityAttributes>) -> Int {
    if context.state.isPaused { return context.state.pausedRemainingSeconds ?? 0 }
    return Int(max(0, context.state.endDate.timeIntervalSince(Date())))
}

@available(iOS 16.1, *)
private func progress(_ context: ActivityViewContext<HabitActivityAttributes>) -> Double {
    let total = max(1, context.state.totalSeconds)
    let remaining = remainingSeconds(context)
    return 1 - Double(remaining) / Double(total)
}

@available(iOS 16.1, *)
private struct RemainingView: View {
    let context: ActivityViewContext<HabitActivityAttributes>
    var body: some View {
        Text(remainingString).monospacedDigit()
    }
    private var remainingString: String {
        let secs = remainingSeconds(context)
        let m = secs / 60
        let s = secs % 60
        return String(format: "%02d:%02d", m, s)
    }
}


