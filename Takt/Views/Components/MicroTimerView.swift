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
        ZStack {
            // Animated background
            AnimatedMeshBackground()

            VStack(spacing: 32) {
                Spacer()

                // Habit info
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.primary.opacity(0.15))
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)
                            .scaleEffect(isRunning ? 1.1 : 1)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isRunning)

                        Text(habit.emoji)
                            .font(.system(size: 80))
                            .scaleEffect(didStart ? 1 : 0.5)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: didStart)
                    }

                    Text(habit.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                // Timer circle
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color("PrimaryColor").opacity(0.1), lineWidth: 20)
                        .frame(width: 250, height: 250)

                    // Progress circle
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient.primary,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)
                        .animation(.easeInOut(duration: 0.5), value: remaining)
                        .shadow(color: Color("PrimaryColor").opacity(0.5), radius: 10, x: 0, y: 0)

                    // Pulsing effect when running
                    if isRunning {
                        Circle()
                            .stroke(LinearGradient.primary.opacity(0.3), lineWidth: 30)
                            .frame(width: 250, height: 250)
                            .blur(radius: 10)
                            .scaleEffect(didStart ? 1.1 : 0.9)
                            .animation(
                                .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: didStart
                            )
                    }

                    // Time display
                    VStack(spacing: 8) {
                        Text(timeString)
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .contentTransition(.numericText())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: remaining <= 10 ? [Color("Warning"), Color("SecondaryColor")] : [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(isRunning ? "Focus Time" : "Paused")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .scaleEffect(didStart ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: didStart)

                Spacer()

                // Control buttons
                HStack(spacing: 16) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isRunning.toggle()
                        }
                    } label: {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }
                    .buttonStyle(IconButtonStyle(size: 60, backgroundColor: Color("PrimaryColor")))

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                    .buttonStyle(IconButtonStyle(size: 50, backgroundColor: Color("SecondaryColor")))

                    Button {
                        finishAndLog()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(IconButtonStyle(size: 60, backgroundColor: Color("Success")))
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: didComplete)
        .sensoryFeedback(.impact(weight: .light), trigger: isRunning)
        .task(id: isRunning) { await runIfNeeded() }
        .task {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                didStart = true
            }
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
