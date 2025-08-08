import SwiftData
import SwiftUI

struct StarterTemplatesView: View {
    @Environment(\.modelContext) private var context

    private struct Template: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let duration: Int
        let blurb: LocalizedStringKey
    }

    private var templates: [Template] = [
        .init(name: "Water Break", emoji: "💧", duration: 30, blurb: "template_water_blurb"),
        .init(name: "Desk Stretch", emoji: "🧘", duration: 60, blurb: "template_stretch_blurb"),
        .init(name: "Inbox Skim", emoji: "📬", duration: 90, blurb: "template_inbox_blurb"),
    ]

    var body: some View {
        List(templates) { t in
            VStack(alignment: .leading, spacing: 6) {
                HStack { Text(t.emoji); Text(t.name).font(.headline) }
                Text(t.blurb).font(.subheadline).foregroundStyle(.secondary)
                Button("templates_add") { add(t) }.buttonStyle(HapticButtonStyle())
            }
            .padding(.vertical, 6)
        }
        .navigationTitle(Text("templates_title"))
    }

    private func add(_ t: Template) {
        let habit = Habit(name: t.name, emoji: t.emoji, defaultDurationSeconds: t.duration)
        context.insert(habit)
        try? context.save()
    }
}

#Preview { StarterTemplatesView() }
