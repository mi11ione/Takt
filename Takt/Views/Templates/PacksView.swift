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
        ScrollView {
            VStack(spacing: 16) {
                ForEach(packs) { pack in
                    Card(style: .glass) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(pack.title)
                                .font(.headline)
                            ForEach(pack.items, id: \.1) { item in
                                HStack(spacing: 12) {
                                    Text(item.0).font(.title3)
                                    Text(item.1).font(.body)
                                    Spacer()
                                    Text("\(item.2 / 60)m")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(10)
                                .background(.thinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Border"), lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            Button("packs_install") { install(pack) }
                                .buttonStyle(BouncyButtonStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text("packs_title"))
        .appBackground()
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
