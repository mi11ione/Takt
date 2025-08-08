import AppIntents
import SwiftData

struct StartHabitTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Habit Timer"

    @Parameter(title: "Habit name")
    var name: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: .init(stringLiteral: "Starting timer for \(name)"))
    }
}

struct StartChainIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Chain"

    @Parameter(title: "Chain name")
    var name: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        .result(dialog: .init(stringLiteral: "Starting chain \(name)"))
    }
}
