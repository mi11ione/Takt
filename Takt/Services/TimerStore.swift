import Foundation
import Observation
import SwiftData
import SwiftUI

@MainActor
@Observable
final class TimerStore {
    static let shared = TimerStore()

    private init() {}

    var activeHabit: Habit?
    var totalSeconds: Int = 0
    var remainingSeconds: Int = 0
    var isRunning: Bool = false

    private var tickingTask: Task<Void, Never>?

    func start(for habit: Habit, seconds: Int) {
        // If the same habit is already running, ignore
        if let current = activeHabit, current.id == habit.id, remainingSeconds > 0 { return }
        cancel()
        activeHabit = habit
        totalSeconds = max(10, seconds)
        remainingSeconds = totalSeconds
        isRunning = true
        startLiveActivity()
        startTicking()
    }

    func pause() {
        isRunning = false
        tickingTask?.cancel()
        tickingTask = nil
        Task { await HabitActivityManager.shared.pause(remainingSeconds: remainingSeconds) }
    }

    func resume() {
        guard activeHabit != nil, remainingSeconds > 0 else { return }
        isRunning = true
        Task { await HabitActivityManager.shared.resume() }
        startTicking()
    }

    func cancel() {
        isRunning = false
        tickingTask?.cancel()
        tickingTask = nil
        Task { await HabitActivityManager.shared.end() }
        activeHabit = nil
        totalSeconds = 0
        remainingSeconds = 0
    }

    func completeAndLog(using context: ModelContext) {
        guard let habit = activeHabit else { return }
        let entry = HabitEntry(performedAt: .now, durationSeconds: totalSeconds, habit: habit)
        context.insert(entry)
        try? context.save()
        Task { await HabitActivityManager.shared.end() }
        // Reset inline state explicitly without ending another activity again
        isRunning = false
        tickingTask?.cancel()
        tickingTask = nil
        activeHabit = nil
        totalSeconds = 0
        remainingSeconds = 0
    }

    private func startTicking() {
        tickingTask = Task { [weak self] in
            guard let self else { return }
            while remainingSeconds > 0, isRunning {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
                if !isRunning { break }
                remainingSeconds -= 1
            }
            if remainingSeconds <= 0 {
                // Auto-complete without logging; UI should explicitly log
                // Keep live activity ending handled by caller when logging
                isRunning = false
            }
        }
    }

    private func startLiveActivity() {
        guard let habit = activeHabit else { return }
        Task { await HabitActivityManager.shared.start(habit: habit, durationSeconds: totalSeconds) }
    }
}
