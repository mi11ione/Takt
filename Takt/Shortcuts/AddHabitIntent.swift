import AppIntents

struct AddHabitIntent: AppIntent {
    static var title: LocalizedStringResource = "shortcut_add_habit_title"
    static var description = IntentDescription("shortcut_add_habit_desc")

    @Parameter(title: "shortcut_add_habit_param_name")
    var name: String

    init() {}

    func perform() async throws -> some IntentResult & ProvidesDialog {
        if name.isEmpty {
            return .result(dialog: "shortcut_add_habit_prompt")
        }
        return .result(dialog: .init(stringLiteral: "Added \(name)"))
    }
}
