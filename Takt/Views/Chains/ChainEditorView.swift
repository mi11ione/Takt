import SwiftData
import SwiftUI

struct ChainEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var chain: Chain?

    @Query(filter: #Predicate<Habit> { $0.archivedAt == nil }, sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var allHabits: [Habit]

    @State private var name: String = ""
    @State private var colorName: String = "blue"
    @State private var selected: [Habit] = []

    var body: some View {
        Form {
            Section(header: Text("chaineditor_basics")) {
                TextField("chaineditor_name_placeholder", text: $name)
                colorPicker
            }
            Section(header: Text("chaineditor_items")) {
                if allHabits.isEmpty {
                    Text("chaineditor_no_habits_hint").foregroundStyle(.secondary)
                } else {
                    // Selected (reorderable)
                    if selected.isEmpty {
                        Text("chaineditor_select_hint").foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach(selected, id: \.id) { habit in
                                HStack { Text(habit.emoji); Text(habit.name) }
                            }
                            .onMove { indices, newOffset in
                                selected.move(fromOffsets: indices, toOffset: newOffset)
                            }
                        }
                        .frame(minHeight: 44)
                    }
                    Divider()
                    // Available to add
                    ForEach(unselectedHabits, id: \.id) { habit in
                        Button {
                            add(habit)
                        } label: {
                            HStack { Text(habit.emoji); Text(habit.name); Spacer(); Image(systemName: "plus.circle") }
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(chain == nil ? "chaineditor_new_title" : "chaineditor_edit_title"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button("common_cancel") { dismiss() } }
            ToolbarItem(placement: .topBarTrailing) { Button("common_save") { save() }.bold().disabled(name.trimmingCharacters(in: .whitespaces).isEmpty) }
            ToolbarItem(placement: .automatic) { EditButton() }
        }
        .onAppear { if let chain { load(chain) } }
    }

    private var colorPicker: some View {
        Picker("chaineditor_color", selection: $colorName) {
            Text("Blue").tag("blue")
            Text("Green").tag("green")
            Text("Orange").tag("orange")
            Text("Purple").tag("purple")
            Text("Pink").tag("pink")
        }
    }

    private func load(_ chain: Chain) {
        name = chain.name
        colorName = chain.colorName
        selected = chain.items.sorted { $0.order < $1.order }.compactMap(\.habit)
    }

    private func save() {
        let items = selected.enumerated().map { idx, habit in ChainItem(order: idx, habit: habit) }
        if let chain {
            chain.name = name
            chain.colorName = colorName
            chain.items = items
        } else {
            let newChain = Chain(name: name, colorName: colorName)
            newChain.items = items
            context.insert(newChain)
        }
        try? context.save()
        dismiss()
    }

    private var unselectedHabits: [Habit] {
        let selectedIds = Set(selected.map(\ .id))
        return allHabits.filter { !selectedIds.contains($0.id) }
    }

    private func add(_ habit: Habit) { if !selected.contains(where: { $0.id == habit.id }) { selected.append(habit) } }
}

#Preview { NavigationStack { ChainEditorView(chain: nil) } }
