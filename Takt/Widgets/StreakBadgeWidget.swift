// Streak Badge Widget – add to Widget Extension target membership.
import WidgetKit
import SwiftUI
import SwiftData

struct StreakBadgeEntry: TimelineEntry { let date: Date; let emoji: String; let days: Int }

struct StreakBadgeProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakBadgeEntry { .init(date: .now, emoji: "🧘", days: 5) }
    func getSnapshot(in context: Context, completion: @escaping (StreakBadgeEntry) -> Void) { completion(placeholder(in: context)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakBadgeEntry>) -> Void) {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let model = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.isFavorite == true && $0.archivedAt == nil }, sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdAt)])
            let habits = (try? model.fetch(descriptor)) ?? []
            if let habit = habits.first {
                let days = StreakCalculator.currentStreakDays(for: habit.entries.map(\.performedAt))
                completion(Timeline(entries: [.init(date: .now, emoji: habit.emoji, days: days)], policy: .after(.now.addingTimeInterval(3600))))
                return
            }
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
        } catch {
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
        }
    }
}

struct StreakBadgeWidgetView: View {
    let entry: StreakBadgeEntry
    var body: some View {
        ZStack {
            Circle().fill(Color("Card")).overlay(Circle().stroke(Color("Border"), lineWidth: 1))
            VStack(spacing: 1) {
                Text(entry.emoji).font(.system(size: 12))
                Text("\(entry.days)").font(.caption2).bold().monospacedDigit()
            }
        }
    }
}

struct StreakBadgeWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "takt.streak.badge", provider: StreakBadgeProvider()) { entry in
            StreakBadgeWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_streak_title")
        .description("widget_streak_desc")
        .supportedFamilies([.accessoryCircular])
    }
}

#Preview(as: .accessoryCircular) { StreakBadgeWidget() } timeline: {
    StreakBadgeEntry(date: .now, emoji: "💧", days: 3)
}


