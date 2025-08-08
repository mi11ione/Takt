import AppIntents
import SwiftData

struct StartHabitTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Habit Timer"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Habit name")
    var name: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        UserDefaults.standard.set("start_timer", forKey: "pendingActionType")
        UserDefaults.standard.set(name, forKey: "pendingActionName")
        return .result(dialog: .init(stringLiteral: "Starting timer for \(name)"))
    }
}

struct StartChainIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Chain"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Chain name")
    var name: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        UserDefaults.standard.set("start_chain", forKey: "pendingActionType")
        UserDefaults.standard.set(name, forKey: "pendingActionName")
        return .result(dialog: .init(stringLiteral: "Starting chain \(name)"))
    }
}
