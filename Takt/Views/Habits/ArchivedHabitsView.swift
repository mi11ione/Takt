import SwiftData
import SwiftUI

struct ArchivedHabitsView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Habit> { $0.archivedAt != nil }, sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var habits: [Habit]

    var body: some View {
        List(habits, id: \.id) { habit in
            HStack {
                Text(habit.emoji)
                Text(habit.name)
                Spacer()
                Button("habits_unarchive") { unarchive(habit) }
            }
        }
        .navigationTitle(Text("habits_archived_title"))
    }

    private func unarchive(_ habit: Habit) {
        habit.archivedAt = nil
        try? context.save()
    }
}

#Preview { ArchivedHabitsView() }
