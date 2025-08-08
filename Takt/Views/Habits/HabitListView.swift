import SwiftData
import SwiftUI

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Habit> { $0.archivedAt == nil }, sort: [SortDescriptor(\Habit.sortOrder, order: .forward)])
    private var habits: [Habit]

    @State private var showEditor: Bool = false
    @State private var editorHabit: Habit?
    @State private var showTemplates: Bool = false
    @State private var showArchived: Bool = false
    @State private var favoritesOnly: Bool = false
    @State private var showPaywall: Bool = false
    @State private var timerHabit: Habit?
    @State private var showTimerSheet: Bool = false
    @State private var recommended: Habit?
    @State private var recommendedMany: [Habit] = []
    @State private var tick: Int = 0

    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.analytics) private var analytics
    @AppStorage("totalLogCount") private var totalLogCount: Int = 0
    @AppStorage("hasShownPaywallAfterLogs") private var hasShownPaywallAfterLogs: Bool = false
    @AppStorage("paywallVariant") private var paywallVariant: String = ""

    var body: some View {
        List {
            if habits.isEmpty {
                Section {
                    VStack(spacing: 20) {
                        Spacer(minLength: 40)

                        ZStack {
                            Circle()
                                .fill(LinearGradient.primary.opacity(0.15))
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)

                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(LinearGradient.primary)
                                .symbolEffect(.pulse)
                        }

                        VStack(spacing: 8) {
                            Text("takt_empty_title")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("takt_empty_desc")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: 12) {
                            Button("habits_add_first") {
                                editorHabit = nil
                                showEditor = true
                            }
                            .buttonStyle(BouncyButtonStyle())

                            Button("habits_show_templates") {
                                showTemplates = true
                            }
                            .buttonStyle(GlassButtonStyle())
                        }
                        .padding(.top, 10)

                        Spacer(minLength: 40)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }
            } else {
                ForEach(filteredHabits, id: \.id) { habit in
                    HabitRow(habit: habit) {
                        log(habit: habit)
                    } onTimer: {
                        showTimer(habit)
                    }
                    .onTapGesture {
                        editorHabit = habit
                        showEditor = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                archive(habit)
                            }
                        } label: {
                            Label("Archive", systemImage: "archivebox.fill")
                        }
                    }
                    .contextMenu {
                        Button(habit.isFavorite ? "habits_unfavorite" : "habits_favorite") { toggleFavorite(habit) }
                        Button("habits_edit") { editorHabit = habit; showEditor = true }
                        if belongsToAnyChain(habit) {
                            NavigationLink("chains_start_quick", destination: quickStartView(for: habit))
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .onMove(perform: moveHabit)
            }
        }
        .scrollContentBackground(.hidden)
        .appBackground()
        .navigationTitle(Text("habits_title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbar }
        .overlay(alignment: .bottomTrailing) {
            if !habits.isEmpty {
                FloatingActionButton(icon: "plus") {
                    editorHabit = nil
                    showEditor = true
                }
                .padding(20)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .overlay(alignment: .bottom) {
            if let active = TimerStore.shared.activeHabit, TimerStore.shared.remainingSeconds > 0, timerHabit == nil {
                InlineTimerWidget(habit: active, onTap: { timerHabit = active })
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
        }
        .sheet(item: Binding(get: { editorHabit }, set: { editorHabit = $0 })) { item in
            HabitEditorView(habit: item)
        }
        .sheet(isPresented: $showTemplates) {
            NavigationStack { StarterTemplatesView() }
        }
        .sheet(isPresented: $showArchived) {
            NavigationStack { ArchivedHabitsView() }
        }
        .sheet(item: Binding(get: { timerHabit }, set: { timerHabit = $0 })) { item in
            NavigationStack { MicroTimerView(habit: item) }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onAppear { ensureABBucket() }
        .task(id: habits.count + tick) { /* recommendations removed */ }
        .task(id: TimerStore.shared.remainingSeconds) {
            // Nudge the view to refresh overlay progress roughly once a second
            tick = Int.random(in: 0 ... Int.max)
        }
        .task {
            // Lightweight ticker to keep overlay fresh without Combine
            while true {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                tick &+= 1
            }
        }
    }

    private var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    NavigationLink(destination: WeeklyInsightsView()) {
                        Label("insights_title", systemImage: "chart.bar.fill")
                    }
                    NavigationLink(destination: ChainListView()) {
                        Label("chains_title", systemImage: "link")
                    }
                } label: {
                    Image(systemName: "square.grid.2x2")
                        .fontWeight(.medium)
                        .foregroundStyle(Color("PrimaryColor"))
                }
                .accessibilityLabel(Text("habits_nav_menu"))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Toggle(isOn: $favoritesOnly.animation(.spring())) {
                        Label("habits_favorites_only", systemImage: favoritesOnly ? "star.fill" : "star")
                    }
                    Divider()
                    Button {
                        showTemplates = true
                    } label: {
                        Label("habits_show_templates", systemImage: "sparkles")
                    }
                    Button {
                        showArchived = true
                    } label: {
                        Label("habits_show_archived", systemImage: "archivebox")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("PrimaryColor"))
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

    private func showTimer(_ habit: Habit) {
        timerHabit = habit
        // Keep TimerStore in sync for inline widget/live activity visibility
        TimerStore.shared.start(for: habit, seconds: habit.defaultDurationSeconds)
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

    private func moveHabit(from source: IndexSet, to destination: Int) {
        var items = filteredHabits
        items.move(fromOffsets: source, toOffset: destination)
        for (index, h) in items.enumerated() {
            h.sortOrder = index
        }
        try? context.save()
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

    private func belongsToAnyChain(_ habit: Habit) -> Bool {
        // Check if any ChainItem references this habit (filter in-memory to avoid predicate optional issues)
        let descriptor = FetchDescriptor<ChainItem>()
        let items = (try? context.fetch(descriptor)) ?? []
        return items.contains { $0.habit?.id == habit.id }
    }

    @ViewBuilder
    private func quickStartView(for habit: Habit) -> some View {
        if let (chain, index) = firstChainAndIndex(for: habit) {
            StartChainView(chain: chain, startAt: index)
        } else {
            MicroTimerView(habit: habit)
        }
    }

    private func firstChainAndIndex(for habit: Habit) -> (Chain, Int)? {
        let chainDesc = FetchDescriptor<ChainItem>()
        let items = (try? context.fetch(chainDesc)) ?? []
        guard let item = items.first(where: { $0.habit?.id == habit.id }), let chain = item.chain else { return nil }
        let ordered = chain.items.sorted { $0.order < $1.order }
        if let idx = ordered.firstIndex(where: { $0.habit?.id == habit.id }) { return (chain, idx) }
        return nil
    }
}

private struct RecommendedStrip: View {
    let habits: [Habit]
    let onStart: (Habit) -> Void
    let onLog: (Habit) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(habits, id: \ .id) { habit in
                    Card(style: .glass) {
                        HStack(spacing: 12) {
                            Text(habit.emoji)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(habit.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(String(format: "%d min", habit.defaultDurationSeconds / 60))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 8)
                            Button(action: { onStart(habit) }) { Image(systemName: "timer") }
                                .buttonStyle(IconButtonStyle(size: 34, backgroundColor: Color("PrimaryColor")))
                            Button(action: { onLog(habit) }) { Image(systemName: "checkmark") }
                                .buttonStyle(IconButtonStyle(size: 34, backgroundColor: Color("Success")))
                        }
                    }
                    .frame(width: 260)
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct HabitRow: View {
    let habit: Habit
    let onLog: () -> Void
    let onTimer: () -> Void
    @State private var isAnimating = false

    var body: some View {
        Card(style: .glass) {
            HStack(spacing: 16) {
                // Emoji with background
                ZStack {
                    Circle()
                        .fill(LinearGradient.primary.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Text(habit.emoji)
                        .font(.title2)
                }
                .scaleEffect(isAnimating ? 1.1 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).repeatCount(1, autoreverses: true), value: isAnimating)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(habit.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        if habit.isFavorite {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundStyle(Color("Warning"))
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundStyle(Color("SecondaryColor"))
                        Text(streakText(for: habit))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: 10) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isAnimating = true
                        }
                        onLog()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isAnimating = false
                        }
                    }) {
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(IconButtonStyle(size: 40, backgroundColor: Color("Success")))

                    Button(action: onTimer) {
                        Image(systemName: "timer")
                            .fontWeight(.medium)
                    }
                    .buttonStyle(IconButtonStyle(size: 40, backgroundColor: Color("PrimaryColor")))
                }
            }
        }
        .padding(.horizontal, -14)
        .padding(.vertical, 6)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
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

// Inline timer widget shown at bottom of habit list when a timer is active
private struct InlineTimerWidget: View {
    let habit: Habit
    var onTap: () -> Void = {}
    @State private var animate = false
    @Environment(\.modelContext) private var context

    var body: some View {
        Card(style: .glass) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color("PrimaryColor").opacity(0.08))
                        .frame(width: 44, height: 44)
                    Text(habit.emoji)
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(timeString)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                Spacer()

                HStack(spacing: 12) {
                    Button {
                        if TimerStore.shared.isRunning { TimerStore.shared.pause() } else { TimerStore.shared.resume() }
                    } label: {
                        Image(systemName: TimerStore.shared.isRunning ? "pause.fill" : "play.fill")
                    }
                    .buttonStyle(IconButtonStyle(size: 40, backgroundColor: Color("SecondaryColor")))

                    Button {
                        TimerStore.shared.completeAndLog(using: context)
                    } label: {
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(IconButtonStyle(size: 40, backgroundColor: Color("Success")))
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .padding(.horizontal)
    }

    private var timeString: String {
        let remaining = TimerStore.shared.remainingSeconds
        return String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }
}

#Preview {
    NavigationStack { HabitListView() }
}
