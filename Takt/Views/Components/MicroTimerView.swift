import SwiftData
import SwiftUI

struct MicroTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let habit: Habit

    @State private var didComplete: Bool = false
    @State private var didStart: Bool = false
    @State private var localPaused: Bool = false

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
                            .scaleEffect(TimerStore.shared.isRunning && !localPaused ? 1.1 : 1)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: TimerStore.shared.isRunning && !localPaused)

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
                        .animation(.easeInOut(duration: 0.5), value: TimerStore.shared.remainingSeconds)
                        .shadow(color: Color("PrimaryColor").opacity(0.18), radius: 6, x: 0, y: 0)

                    // Pulsing effect when running
                    if TimerStore.shared.isRunning, !localPaused {
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
                                    colors: TimerStore.shared.remainingSeconds <= 10 ? [Color("Warning"), Color("SecondaryColor")] : [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(TimerStore.shared.isRunning && !localPaused ? "Focus Time" : "Paused")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .scaleEffect(didStart ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: didStart)

                Spacer()

                // Control buttons (equal size, spacing 30): Cancel (red), Pause/Play (yellow), Done (green)
                HStack(spacing: 30) {
                    Button {
                        // Cancel timer completely
                        TimerStore.shared.cancel()
                        Task { await HabitActivityManager.shared.end() }
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                    }
                    .buttonStyle(IconButtonStyle(size: 60, backgroundColor: Color("Danger")))

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            localPaused.toggle()
                            if localPaused {
                                TimerStore.shared.pause()
                            } else {
                                TimerStore.shared.resume()
                            }
                        }
                    } label: {
                        Image(systemName: localPaused ? "play.fill" : "pause.fill")
                            .font(.title2)
                    }
                    .buttonStyle(IconButtonStyle(size: 60, backgroundColor: Color("Warning")))

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
        .sensoryFeedback(.impact(weight: .light), trigger: localPaused)
        .task {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                didStart = true
            }
            // Sync with timer state
            localPaused = !TimerStore.shared.isRunning
        }
        .onChange(of: TimerStore.shared.remainingSeconds) { _, newValue in
            // Check if timer completed naturally
            if newValue <= 0, TimerStore.shared.activeHabit != nil {
                finishAndLog()
            }
        }
        .onDisappear {
            // Don't log anything when sheet is dismissed - timer continues in background
        }
    }

    private var progress: CGFloat {
        guard TimerStore.shared.totalSeconds > 0 else { return 0 }
        return 1 - CGFloat(TimerStore.shared.remainingSeconds) / CGFloat(TimerStore.shared.totalSeconds)
    }

    private var timeString: String {
        let remaining = TimerStore.shared.remainingSeconds
        return String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }

    private func finishAndLog() {
        // Use completeAndLog from TimerStore to ensure proper cleanup
        TimerStore.shared.completeAndLog(using: context)
        didComplete = true
        dismiss()
    }
}

#Preview { NavigationStack { MicroTimerView(habit: Habit(name: "Focus Reset", emoji: "✨")) } }
