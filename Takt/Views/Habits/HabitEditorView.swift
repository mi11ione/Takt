import SwiftData
import SwiftUI

struct HabitEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var habit: Habit?

    @State private var name: String = ""
    @State private var emoji: String = "🔥"
    @State private var duration: Double = 60
    @State private var isFavorite: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("habiteditor_basics")) {
                    TextField("habiteditor_name_placeholder", text: $name)
                    TextField("habiteditor_emoji_placeholder", text: $emoji)
                    Stepper(value: $duration, in: 30 ... 180, step: 30) {
                        Text(String(format: NSLocalizedString("habiteditor_duration_format", comment: ""), Int(duration)))
                    }
                    Toggle("habiteditor_favorite", isOn: $isFavorite)
                }
            }
            .navigationTitle(Text(habit == nil ? "habiteditor_new_title" : "habiteditor_edit_title"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("common_cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) { Button("common_save") { save() }.bold() }
            }
            .onAppear { if let habit { load(habit) } }
        }
    }

    private func load(_ habit: Habit) {
        name = habit.name
        emoji = habit.emoji
        duration = Double(habit.defaultDurationSeconds)
        isFavorite = habit.isFavorite
    }

    private func save() {
        if let habit {
            habit.name = name
            habit.emoji = emoji
            habit.defaultDurationSeconds = Int(duration)
            habit.isFavorite = isFavorite
        } else {
            let newHabit = Habit(name: name, emoji: emoji, isFavorite: isFavorite, defaultDurationSeconds: Int(duration))
            context.insert(newHabit)
        }
        try? context.save()
        dismiss()
    }
}

#Preview { HabitEditorView(habit: nil) }
