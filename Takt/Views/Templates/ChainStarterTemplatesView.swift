import SwiftData
import SwiftUI

struct ChainStarterTemplatesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    struct ChainTemplate: Identifiable {
        let id = UUID()
        let name: String
        let items: [(emoji: String, name: String, duration: Int)]
        let blurb: String
    }

    private let templates: [ChainTemplate] = [
        .init(
            name: "Morning Kickoff",
            items: [("💧", "Water Break", 30), ("🧘", "Desk Stretch", 60), ("📅", "Daily Planning", 300)],
            blurb: "Hydrate, loosen up, plan the day"
        ),
        .init(
            name: "Deep Work Warm‑up",
            items: [("🌬️", "Deep Breathing", 90), ("🧹", "Quick Tidy", 180), ("💻", "Code Review", 900)],
            blurb: "Calm mind, clear desk, quick review"
        ),
        .init(
            name: "Study Sprint",
            items: [("📚", "Open Textbook", 60), ("📝", "Outline", 90), ("🧠", "Recall", 60)],
            blurb: "Prime, outline, recall"
        ),
        .init(
            name: "Reset Break",
            items: [("🚶", "Walk Break", 300), ("💧", "Water Break", 30), ("🌬️", "Deep Breathing", 90)],
            blurb: "Move, hydrate, breathe"
        ),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(templates) { template in
                    Card(style: .glass) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(template.name)
                                    .font(.headline)
                                Spacer()
                                Button("Add Chain") { add(template) }
                                    .buttonStyle(BouncyButtonStyle())
                            }
                            Text(template.blurb)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            ForEach(Array(template.items.enumerated()), id: \.offset) { _, item in
                                HStack(spacing: 10) {
                                    Text(item.emoji).font(.title3)
                                    Text(item.name).font(.body)
                                    Spacer()
                                    Label("\(item.duration / 60)m", systemImage: "timer")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .background(.thinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Border"), lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text("Chain Templates"))
        .background(AppBackground())
    }

    private func add(_ template: ChainTemplate) {
        let chain = Chain(name: template.name)
        context.insert(chain)

        var order = 0
        for item in template.items {
            // Find or create habit by name
            let descriptor = FetchDescriptor<Habit>()
            let existing = (try? context.fetch(descriptor)) ?? []
            let habit = existing.first(where: { $0.name == item.name }) ?? {
                let h = Habit(name: item.name, emoji: item.emoji, defaultDurationSeconds: item.duration)
                context.insert(h)
                return h
            }()
            let ci = ChainItem(order: order, habit: habit, chain: chain)
            context.insert(ci)
            order += 1
        }
        try? context.save()
    }
}

#Preview { NavigationStack { ChainStarterTemplatesView() } }
