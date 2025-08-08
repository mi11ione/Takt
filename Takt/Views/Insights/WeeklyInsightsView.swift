import SwiftData
import SwiftUI

struct WeeklyInsightsView: View {
    @Query private var entries: [HabitEntry]
    @Query private var habits: [Habit]

    var body: some View {
        List {
            Section(header: Text("insights_header")) {
                summaryText()
                if let hour = InsightsEngine().mostConsistentHour(entries: entries) {
                    Text(String(format: NSLocalizedString("insights_best_hour", comment: ""), hour))
                        .foregroundStyle(.secondary)
                }
                NavigationLink(destination: PacksView()) {
                    Label("packs_title", systemImage: "sparkles")
                }
            }
            Section(header: Text("insights_highlights")) {
                ForEach(habits, id: \.id) { habit in
                    let longest = InsightsEngine().longestStreakDays(for: habit)
                    if longest > 1 {
                        HStack { Text(habit.emoji); Text(habit.name); Spacer(); Text("\(longest)d").foregroundStyle(.secondary) }
                    }
                }
            }
        }
        .navigationTitle(Text("insights_title"))
    }

    private func summaryText() -> Text {
        let count = entries.filter { Calendar.autoupdatingCurrent.isDate($0.performedAt, equalTo: .now, toGranularity: .weekOfYear) }.count
        if count == 0 { return Text("insights_weekly_zero") }
        if count == 1 { return Text("insights_weekly_one") }
        return Text(String(format: NSLocalizedString("insights_weekly_multi", comment: ""), count))
    }
}

#Preview { WeeklyInsightsView() }
