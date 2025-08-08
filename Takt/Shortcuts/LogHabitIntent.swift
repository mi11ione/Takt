import AppIntents

struct LogHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "shortcut_log_habit_title"
    static var description = IntentDescription("shortcut_log_habit_desc")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "shortcut_log_habit_done")
    }
}
