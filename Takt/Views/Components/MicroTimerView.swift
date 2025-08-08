import SwiftData
import SwiftUI

struct MicroTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let habit: Habit

    @State private var remaining: Int
    @State private var isRunning: Bool = true
    @State private var didComplete: Bool = false
    @State private var didStart: Bool = false

    init(habit: Habit) {
        self.habit = habit
        _remaining = State(initialValue: max(10, habit.defaultDurationSeconds))
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(habit.emoji).font(.system(size: 64))
            Text(habit.name).font(.title2).bold()
            Card {
                ZStack {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 180, height: 180)
                        .animation(.easeInOut(duration: 0.25), value: remaining)
                        .scaleEffect(didStart ? 1.0 : 0.9)
                        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: didStart)
                    Text(timeString).font(.largeTitle).monospacedDigit()
                        .contentTransition(.numericText())
                }
            }
            HStack(spacing: 16) {
                Button(isRunning ? "timer_pause" : "timer_resume") { isRunning.toggle() }
                    .buttonStyle(SecondaryButtonStyle())
                Button("timer_cancel") { dismiss() }
                    .buttonStyle(SecondaryButtonStyle())
                Button("timer_finish") { finishAndLog() }
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding()
        .navigationTitle(Text("timer_title"))
        .sensoryFeedback(.success, trigger: didComplete)
        .sensoryFeedback(.alignment, trigger: isRunning)
        .task(id: isRunning) { await runIfNeeded() }
        .task {
            didStart = true
            await HabitActivityManager.shared.start(habitName: habit.name, durationSeconds: total)
        }
    }

    private var total: Int { max(10, habit.defaultDurationSeconds) }
    private var progress: CGFloat { 1 - CGFloat(remaining) / CGFloat(total) }
    private var timeString: String { String(format: "%02d:%02d", remaining / 60, remaining % 60) }

    private func runIfNeeded() async {
        guard isRunning else { return }
        let initial = total
        while remaining > 0, isRunning {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if !isRunning { break }
            remaining -= 1
            let progress = 1 - Double(remaining) / Double(initial)
            await HabitActivityManager.shared.updateProgress(progress)
        }
        if remaining <= 0 { finishAndLog() }
    }

    private func finishAndLog() {
        let entry = HabitEntry(performedAt: .now, durationSeconds: total, habit: habit)
        context.insert(entry)
        try? context.save()
        didComplete = true
        Task { await HabitActivityManager.shared.end() }
        dismiss()
    }
}

#Preview { NavigationStack { MicroTimerView(habit: Habit(name: "Focus Reset", emoji: "✨")) } }
