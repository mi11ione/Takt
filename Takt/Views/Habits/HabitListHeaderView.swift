import SwiftUI

struct HabitListHeaderView: View {
    let recommended: Habit?
    let onStart: (Habit) -> Void

    var body: some View {
        if let habit = recommended {
            HStack(spacing: 12) {
                Text(habit.emoji)
                VStack(alignment: .leading) {
                    Text("header_recommended_title").font(.caption).foregroundStyle(.secondary)
                    Text(habit.name).font(.headline)
                }
                Spacer()
                Button("header_start") { onStart(habit) }
                    .buttonStyle(HapticButtonStyle())
            }
            .padding(12)
            .background(.quaternary, in: .rect(cornerRadius: 12))
        }
    }
}

#Preview {
    HabitListHeaderView(recommended: nil, onStart: { _ in })
}
