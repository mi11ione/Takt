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
        ScrollView {
            VStack(spacing: 16) {
                // Basics
                Card(style: .glass) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("chaineditor_basics").font(.headline)
                        TextField("chaineditor_name_placeholder", text: $name)
                            .font(.title3)
                            .padding(.vertical, 4)
                        colorPicker
                    }
                }

                // Selected items
                Card(style: .glass) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("chaineditor_items").font(.headline)
                        if selected.isEmpty {
                            Text("chaineditor_select_hint").foregroundStyle(.secondary).frame(maxWidth: .infinity)
                        } else {
                            ForEach(selected.indices, id: \.self) { i in
                                HStack {
                                    Text(selected[i].emoji)
                                    Text(selected[i].name)
                                    Spacer()
                                    Button(role: .destructive) { selected.remove(at: i) } label: { Image(systemName: "xmark.circle.fill") }
                                        .foregroundStyle(Color("OnSurfaceSecondary"))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(.thinMaterial)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Border"), lineWidth: 1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }

                // Available habits grid
                Card(style: .glass) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("templates_title").font(.headline)
                        if allHabits.isEmpty {
                            Text("chaineditor_no_habits_hint").foregroundStyle(.secondary)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                                ForEach(unselectedHabits, id: \.id) { habit in
                                    Button { add(habit) } label: {
                                        HStack(spacing: 10) {
                                            Text(habit.emoji).font(.title2)
                                            Text(habit.name).font(.body).lineLimit(1)
                                            Spacer()
                                            Image(systemName: "plus.circle.fill").foregroundStyle(Color("PrimaryColor"))
                                        }
                                        .padding(12)
                                        .background(.thinMaterial)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Border"), lineWidth: 1))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text(chain == nil ? "chaineditor_new_title" : "chaineditor_edit_title"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { Button("common_cancel") { dismiss() } }
            ToolbarItem(placement: .topBarTrailing) { Button("common_save") { save() }.bold().disabled(name.trimmingCharacters(in: .whitespaces).isEmpty) }
        }
        .appBackground()
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
