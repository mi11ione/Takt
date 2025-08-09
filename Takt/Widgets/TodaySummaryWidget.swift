// Today Summary Widget – add to Widget Extension target membership.
import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct TodaySummaryEntry: TimelineEntry {
    let date: Date
    let performedToday: Int
    let weeklyCount: Int
    let topStreak: Int
}

struct TodaySummaryProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodaySummaryEntry {
        TodaySummaryEntry(date: .now, performedToday: 1, weeklyCount: 5, topStreak: 7)
    }
    func getSnapshot(in context: Context, completion: @escaping (TodaySummaryEntry) -> Void) {
        completion(placeholder(in: context))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<TodaySummaryEntry>) -> Void) {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let model = ModelContext(container)
            let descriptor = FetchDescriptor<HabitEntry>()
            let entries = (try? model.fetch(descriptor)) ?? []
            let cal = Calendar.autoupdatingCurrent
            let today = entries.filter { cal.isDateInToday($0.performedAt) }.count
            let weekly = InsightsEngine().weeklyEntryCount(entries: entries)
            // top streak across all habits
            let habits = (try? model.fetch(FetchDescriptor<Habit>())) ?? []
            let top = habits.map { StreakCalculator.currentStreakDays(for: $0.entries.map(\.performedAt)) }.max() ?? 0
            let entry = TodaySummaryEntry(date: .now, performedToday: today, weeklyCount: weekly, topStreak: top)
            let next = cal.startOfDay(for: cal.date(byAdding: .day, value: 1, to: .now) ?? .now)
            completion(Timeline(entries: [entry], policy: .after(next)))
        } catch {
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
        }
    }
}

struct TodaySummaryWidgetView: View {
    let entry: TodaySummaryEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Today").font(.headline)
                Spacer()
                Link(destination: URL(string: "takt://start-suggested")!) {
                    Label("Start Suggested", systemImage: "play.circle.fill")
                }
                .buttonStyle(.borderedProminent)
            }
            HStack(spacing: 12) {
                metric("Done", value: entry.performedToday)
                metric("This Week", value: entry.weeklyCount)
                metric("Top Streak", value: entry.topStreak)
            }
            Link(destination: URL(string: "takt://nudge-now")!) {
                Label("Nudge me", systemImage: "bell")
            }
            .buttonStyle(.bordered)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            Color("Card")
        }
    }

    @ViewBuilder
    private func metric(_ title: LocalizedStringKey, value: Int) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption).foregroundStyle(Color("OnSurfaceSecondary"))
            Text("\(value)").font(.title3).bold().monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TodaySummaryWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "takt.today.summary", provider: TodaySummaryProvider()) { entry in
            TodaySummaryWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_today_title")
        .description("widget_today_desc")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) { TodaySummaryWidget() } timeline: {
    TodaySummaryEntry(date: .now, performedToday: 2, weeklyCount: 6, topStreak: 10)
}


