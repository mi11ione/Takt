import SwiftData
import SwiftUI

struct PacksView: View {
    @Environment(\.modelContext) private var context

    struct Pack: Identifiable { let id: String; let title: LocalizedStringKey; let items: [(String, String, Int)] }
    private let packs: [Pack] = [
        .init(id: "focus_reset", title: "pack_focus_reset", items: [("💧", "Water Break", 30), ("🧘", "Desk Stretch", 60), ("📬", "Inbox Skim", 90)]),
        .init(id: "study_sprint", title: "pack_study_sprint", items: [("📚", "Open Textbook", 60), ("📝", "Outline", 90), ("🧠", "Recall", 60)]),
    ]

    var body: some View {
        List(packs) { pack in
            Section(header: Text(pack.title)) {
                ForEach(pack.items, id: \.1) { item in
                    HStack { Text(item.0); Text(item.1); Spacer(); Text("\(item.2)s").foregroundStyle(.secondary) }
                }
                Button("packs_install") { install(pack) }.buttonStyle(HapticButtonStyle())
            }
        }
        .navigationTitle(Text("packs_title"))
    }

    private func install(_ pack: Pack) {
        for item in pack.items {
            let habit = Habit(name: item.1, emoji: item.0, defaultDurationSeconds: item.2, sourcePackId: pack.id)
            context.insert(habit)
        }
        try? context.save()
    }
}

#Preview { PacksView() }
