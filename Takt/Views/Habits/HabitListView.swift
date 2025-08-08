import SwiftData
import SwiftUI

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Habit> { $0.archivedAt == nil }, sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var habits: [Habit]

    @State private var showEditor: Bool = false
    @State private var editorHabit: Habit?
    @State private var showTemplates: Bool = false
    @State private var showArchived: Bool = false
    @State private var favoritesOnly: Bool = false
    @State private var showPaywall: Bool = false

    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.analytics) private var analytics
    @AppStorage("totalLogCount") private var totalLogCount: Int = 0
    @AppStorage("hasShownPaywallAfterLogs") private var hasShownPaywallAfterLogs: Bool = false
    @AppStorage("paywallVariant") private var paywallVariant: String = ""

    var body: some View {
        List {
            if habits.isEmpty {
                Section {
                    ContentUnavailableView {
                        Label("takt_empty_title", systemImage: "sparkles")
                    } description: {
                        Text("takt_empty_desc")
                    } actions: {
                        Button("habits_add_first") { editorHabit = nil; showEditor = true }
                        Button("habits_show_templates") { showTemplates = true }
                            .buttonStyle(HapticButtonStyle())
                    }
                }
            } else {
                ForEach(filteredHabits, id: \.id) { habit in
                    HabitRow(habit: habit) {
                        log(habit: habit)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) { archive(habit) } label: { Label("Archive", systemImage: "archivebox") }
                    }
                    .contextMenu {
                        Button(habit.isFavorite ? "habits_unfavorite" : "habits_favorite") { toggleFavorite(habit) }
                        Button("habits_edit") { editorHabit = habit; showEditor = true }
                    }
                }
            }
        }
        .navigationTitle(Text("habits_title"))
        .toolbar { toolbar }
        .sheet(isPresented: $showEditor) {
            HabitEditorView(habit: editorHabit)
        }
        .sheet(isPresented: $showTemplates) {
            NavigationStack { StarterTemplatesView() }
        }
        .sheet(isPresented: $showArchived) {
            NavigationStack { ArchivedHabitsView() }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear { ensureABBucket() }
    }

    private var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                NavigationLink(destination: WeeklyInsightsView()) {
                    Label("insights_title", systemImage: "chart.bar.fill")
                }
                .accessibilityLabel(Text("insights_title"))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { editorHabit = nil; showEditor = true } label: { Image(systemName: "plus") }
                    .accessibilityLabel(Text("habits_add"))
                    .buttonStyle(HapticButtonStyle())
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Toggle(isOn: $favoritesOnly) {
                        Label("habits_favorites_only", systemImage: favoritesOnly ? "star.fill" : "star")
                    }
                    Button {
                        showTemplates = true
                    } label: { Label("habits_show_templates", systemImage: "sparkles") }
                    Button {
                        showArchived = true
                    } label: { Label("habits_show_archived", systemImage: "archivebox") }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .accessibilityLabel(Text("habits_menu"))
            }
        }
    }

    private func log(habit: Habit) {
        let entry = HabitEntry(performedAt: .now, durationSeconds: habit.defaultDurationSeconds, habit: habit)
        context.insert(entry)
        try? context.save()
        analytics.log(event: "habit_logged", ["habitId": habit.id.uuidString])
        totalLogCount += 1
        maybeGateWithPaywall()
    }

    private func toggleFavorite(_ habit: Habit) {
        habit.isFavorite.toggle()
        try? context.save()
    }

    private func archive(_ habit: Habit) {
        habit.archivedAt = .now
        try? context.save()
        analytics.log(event: "habit_archived", ["habitId": habit.id.uuidString])
    }

    private var filteredHabits: [Habit] {
        favoritesOnly ? habits.filter(\.isFavorite) : habits
    }

    private func ensureABBucket() {
        if paywallVariant.isEmpty { paywallVariant = Bool.random() ? "after3" : "onboarding" }
    }

    private func maybeGateWithPaywall() {
        guard !hasShownPaywallAfterLogs, paywallVariant == "after3", totalLogCount >= 3 else { return }
        Task { @MainActor in
            let active = await subscriptions.isSubscribed()
            if !active { showPaywall = true; hasShownPaywallAfterLogs = true }
        }
    }
}

private struct HabitRow: View {
    let habit: Habit
    let onLog: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(habit.emoji)
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name).font(.headline)
                Text(streakText(for: habit)).font(.footnote).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: habit.isFavorite ? "star.fill" : "star")
                .foregroundStyle(habit.isFavorite ? .yellow : .secondary)
                .accessibilityLabel(Text("habits_favorite_star_accessibility"))
            Button(action: onLog) { Image(systemName: "checkmark.circle.fill").foregroundStyle(.tint) }
                .buttonStyle(HapticButtonStyle())
        }
        .accessibilityElement(children: .combine)
    }

    private func streakText(for habit: Habit) -> String {
        let dates = habit.entries.map(\ .performedAt)
        let streak = StreakCalculator.currentStreakDays(for: dates)
        if streak == 0 { return NSLocalizedString("habits_streak_none", comment: "") }
        if streak == 1 { return NSLocalizedString("habits_streak_one", comment: "") }
        return String(format: NSLocalizedString("habits_streak_multi", comment: ""), streak)
    }
}

#Preview {
    NavigationStack { HabitListView() }
}
