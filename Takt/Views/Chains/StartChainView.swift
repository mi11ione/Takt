import SwiftData
import SwiftUI

struct StartChainView: View {
    @Environment(\.modelContext) private var context
    let chain: Chain
    let startAt: Int?

    @State private var currentIndex: Int = 0
    @State private var isComplete: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            if isComplete {
                Image(systemName: "checkmark.seal.fill").font(.system(size: 56)).foregroundStyle(.green)
                Text("chain_complete_message").font(.title3)
            } else if let step = stepHabit {
                Text(step.emoji).font(.system(size: 48))
                Text(step.name).font(.title2).bold()
                HStack(spacing: 16) {
                    Button("chain_skip") { next() }.buttonStyle(HapticButtonStyle())
                    Button("chain_log") { log(step) }.buttonStyle(HapticButtonStyle())
                }
            } else {
                ContentUnavailableView("chains_unavailable", systemImage: "link")
            }
        }
        .padding()
        .navigationTitle(Text("start_chain_title"))
        .onAppear {
            if let startAt, startAt >= 0 { currentIndex = startAt }
        }
    }

    private var orderedHabits: [Habit] {
        chain.items.sorted { $0.order < $1.order }.compactMap(\.habit)
    }

    private var stepHabit: Habit? { orderedHabits[safe: currentIndex] }

    private func next() {
        let nextIndex = currentIndex + 1
        if nextIndex >= orderedHabits.count { isComplete = true } else { currentIndex = nextIndex }
    }

    private func log(_ habit: Habit) {
        let entry = HabitEntry(performedAt: .now, durationSeconds: habit.defaultDurationSeconds, habit: habit)
        context.insert(entry)
        try? context.save()
        next()
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}

#Preview { StartChainView(chain: Chain(name: "Focus Reset"), startAt: 0) }
