import AppIntents

struct TaktShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue

    static var appShortcuts: [AppShortcut] {
        [
            AppShortcut(
                intent: LogHabitIntent(),
                phrases: ["Log a habit in \(.applicationName)"],
                shortTitle: "Log Habit",
                systemImageName: "checkmark.circle"
            ),
            AppShortcut(
                intent: OpenStreaksIntent(),
                phrases: ["Open streaks in \(.applicationName)"],
                shortTitle: "Open Streaks",
                systemImageName: "flame"
            ),
            AppShortcut(
                intent: AddHabitIntent(),
                phrases: ["Add a habit in \(.applicationName)"],
                shortTitle: "Add Habit",
                systemImageName: "plus.circle"
            ),
        ]
    }
}
