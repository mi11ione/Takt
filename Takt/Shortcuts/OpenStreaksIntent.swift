import AppIntents

struct OpenStreaksIntent: AppIntent {
    static var title: LocalizedStringResource = "shortcut_open_streaks_title"
    static var description = IntentDescription("shortcut_open_streaks_desc")

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: "shortcut_open_streaks_done")
    }
}
