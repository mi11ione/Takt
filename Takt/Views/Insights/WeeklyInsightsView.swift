import Charts
import SwiftData
import SwiftUI

struct WeeklyInsightsView: View {
    @Query private var entries: [HabitEntry]
    @Query private var habits: [Habit]
    @State private var showContent = false
    @State private var selectedMetric: InsightMetric = .consistency

    enum InsightMetric: String, CaseIterable {
        case consistency = "Consistency"
        case streaks = "Streaks"
        case timing = "Best Times"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header card
                Card(style: .gradient) {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("insights_header")
                                    .font(.headline)
                                    .foregroundStyle(Color("OnEmphasis").opacity(0.88))

                                summaryText()
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("OnEmphasis"))
                            }

                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(Color("OnEmphasis").opacity(0.2))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color("OnEmphasis"))
                                    .symbolEffect(.pulse)
                            }
                        }

                        if let hour = InsightsEngine().mostConsistentHour(entries: entries) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundStyle(Color("OnEmphasis").opacity(0.88))
                                Text(String(format: NSLocalizedString("insights_best_hour", comment: ""), hour))
                                    .foregroundStyle(Color("OnEmphasis").opacity(0.88))
                                Spacer()
                            }
                            .font(.subheadline)
                        } else {
                            HStack {
                                Image(systemName: "clock.slash.fill")
                                    .foregroundStyle(Color("OnEmphasis").opacity(0.88))
                                Text("No consistent time yet")
                                    .foregroundStyle(Color("OnEmphasis").opacity(0.88))
                                Spacer()
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)

                // Metric selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(InsightMetric.allCases, id: \.self) { metric in
                            MetricPill(
                                title: metric.rawValue,
                                isSelected: selectedMetric == metric
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedMetric = metric
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, -16)

                // Content based on selected metric
                VStack(spacing: 16) {
                    switch selectedMetric {
                    case .consistency:
                        ConsistencyChart(entries: entries)
                    case .streaks:
                        StreaksView(habits: habits)
                    case .timing:
                        TimingInsights(entries: entries)
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                // Quick actions
                VStack(spacing: 12) {
                    NavigationLink(destination: PacksView()) {
                        ActionCard(
                            icon: "sparkles",
                            title: "packs_title",
                            subtitle: "Discover new habit ideas",
                            color: Color("PrimaryColor")
                        )
                    }

                    NavigationLink(destination: ChainListView()) {
                        ActionCard(
                            icon: "link",
                            title: "chains_title",
                            subtitle: "Create habit sequences",
                            color: Color("SecondaryColor")
                        )
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle(Text("insights_title"))
        .navigationBarTitleDisplayMode(.large)
        .background(AppBackground())
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    private func summaryText() -> Text {
        let count = entries.filter { Calendar.autoupdatingCurrent.isDate($0.performedAt, equalTo: .now, toGranularity: .weekOfYear) }.count
        if count == 0 { return Text("insights_weekly_zero") }
        if count == 1 { return Text("insights_weekly_one") }
        return Text(String(format: NSLocalizedString("insights_weekly_multi", comment: ""), count))
    }
}

// Supporting Views
struct MetricPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(background())
                .foregroundStyle(isSelected ? .white : .primary)
        }
    }

    @ViewBuilder
    private func background() -> some View {
        if isSelected == true {
            Capsule()
                .fill(LinearGradient.primary)
        } else {
            Capsule()
                .fill(Color("PrimaryColor").opacity(0.1))
        }
    }
}

struct ConsistencyChart: View {
    let entries: [HabitEntry]

    var body: some View {
        Card(style: .elevated) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Weekly Activity")
                    .font(.headline)

                Spacer()

                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(0 ..< 7) { dayOffset in
                        let date = Calendar.current.date(byAdding: .day, value: dayOffset - 6, to: Date())!
                        let dayEntries = entries.filter { Calendar.current.isDate($0.performedAt, inSameDayAs: date) }

                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(LinearGradient.primary.opacity(dayEntries.isEmpty ? 0.2 : 0.8))
                                .frame(width: 40, height: CGFloat(dayEntries.count * 20 + 10))
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: dayEntries.count)

                            Text(dayName(for: date))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct StreaksView: View {
    let habits: [Habit]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(habits.sorted(by: { InsightsEngine().longestStreakDays(for: $0) > InsightsEngine().longestStreakDays(for: $1) }).prefix(5), id: \.id) { habit in
                let longest = InsightsEngine().longestStreakDays(for: habit)
                if longest > 0 {
                    Card(style: .glass) {
                        HStack {
                            Text(habit.emoji)
                                .font(.title2)

                            VStack(alignment: .leading) {
                                Text(habit.name)
                                    .font(.headline)
                                Text("\(longest) day streak")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(Color("Success").opacity(0.15))
                                    .frame(width: 50, height: 50)

                                Text("\(longest)")
                                    .font(.headline)
                                    .foregroundStyle(Color("Success"))
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TimingInsights: View {
    let entries: [HabitEntry]

    var body: some View {
        Card(style: .elevated) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Activity by Hour")
                    .font(.headline)

                let hourCounts = Dictionary(grouping: entries) { entry in
                    Calendar.current.component(.hour, from: entry.performedAt)
                }.mapValues { $0.count }
                let total = hourCounts.values.reduce(0, +)
                if total == 0 {
                    HStack {
                        Spacer()
                        Text("No activity yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    let topHours = hourCounts.sorted { $0.value > $1.value }.prefix(3)
                    VStack(spacing: 12) {
                        ForEach(Array(topHours), id: \.key) { hour, count in
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color("PrimaryColor").opacity(0.1))
                                        .frame(width: 40, height: 40)

                                    Text("\(hour):00")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }

                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(LinearGradient.primary)
                                        .frame(width: geometry.size.width * CGFloat(count) / CGFloat(hourCounts.values.max() ?? 1))
                                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: count)
                                }
                                .frame(height: 30)

                                Text("\(count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 30)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ActionCard: View {
    let icon: String
    let title: LocalizedStringKey
    let subtitle: String
    let color: Color

    var body: some View {
        Card(style: .glass) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview { WeeklyInsightsView() }
