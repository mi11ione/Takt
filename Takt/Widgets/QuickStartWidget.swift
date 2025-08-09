// Quick Start Widget – add this file to the Widget Extension target membership in Xcode.
import WidgetKit
import SwiftUI
import AppIntents
import SwiftData

// MARK: - Configuration Intent

struct QuickStartConfiguration: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "widget_quick_start_title"
    static var description = IntentDescription("widget_quick_start_desc")

    @Parameter(title: "widget_param_habit")
    var habit: HabitEntity?

    init() { self.habit = nil }
}

// MARK: - Entry

struct QuickStartEntry: TimelineEntry {
    let date: Date
    let habitID: UUID
    let name: String
    let emoji: String
    let isPaused: Bool
    let remainingSeconds: Int
}

// MARK: - Provider

struct QuickStartProvider: AppIntentTimelineProvider {
    typealias Intent = QuickStartConfiguration

    func placeholder(in context: Context) -> QuickStartEntry {
        QuickStartEntry(date: .now, habitID: UUID(), name: "Hydrate", emoji: "💧", isPaused: false, remainingSeconds: 60)
    }

    func snapshot(for configuration: QuickStartConfiguration, in context: Context) async -> QuickStartEntry {
        await entry(for: configuration)
    }

    func timeline(for configuration: QuickStartConfiguration, in context: Context) async -> Timeline<QuickStartEntry> {
        let entry = await entry(for: configuration)
        let next = Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(900)
        return Timeline(entries: [entry], policy: .after(next))
    }

    private func entry(for configuration: QuickStartConfiguration) async -> QuickStartEntry {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let model = ModelContext(container)
            let habits = (try? model.fetch(FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil }))) ?? []
            if let selected = configuration.habit, let habit = habits.first(where: { $0.id == selected.id }) {
                return QuickStartEntry(date: .now, habitID: habit.id, name: habit.name, emoji: habit.emoji, isPaused: false, remainingSeconds: habit.defaultDurationSeconds)
            }
        } catch {}
        return QuickStartEntry(date: .now, habitID: UUID(), name: "Hydrate", emoji: "💧", isPaused: false, remainingSeconds: 60)
    }
}

// MARK: - View

struct QuickStartWidgetView: View {
    var entry: QuickStartEntry

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.emoji).font(.system(size: 28))
            Text(entry.name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Link(destination: URL(string: "takt://start-timer?id=\(entry.habitID.uuidString)")!) {
                    Image(systemName: "play.fill")
                }
                .buttonStyle(.borderedProminent)

                Link(destination: URL(string: "takt://complete-and-log?id=\(entry.habitID.uuidString)&total=\(entry.remainingSeconds)")!) {
                    Image(systemName: "checkmark")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color("Card")
        }
    }
}

// MARK: - Widget

struct QuickStartWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "takt.quickstart", intent: QuickStartConfiguration.self, provider: QuickStartProvider()) { entry in
            QuickStartWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_quick_start_display")
        .description("widget_quick_start_desc")
        .supportedFamilies([.systemSmall, .accessoryRectangular])
    }
}

#Preview(as: .systemSmall) {
    QuickStartWidget()
} timeline: {
    QuickStartEntry(date: .now, habitID: UUID(), name: "Hydrate", emoji: "💧", isPaused: false, remainingSeconds: 60)
}


