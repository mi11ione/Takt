import SwiftData
import SwiftUI

struct HabitSuggestionView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Habit> { $0.archivedAt == nil })
    private var habits: [Habit]

    let suggestion: TemplateLibrary.Template?
    let onAdd: () -> Void
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var isAdded = false

    var body: some View {
        if let suggestion {
            Card(style: .glass) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Try this!")
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button(action: onDismiss) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.tertiary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    HStack(spacing: 12) {
                        // Emoji with animated background
                        ZStack {
                            Circle()
                                .fill(LinearGradient.primary.opacity(0.15))
                                .frame(width: 60, height: 60)
                                .blur(radius: 10)
                                .scaleEffect(showContent ? 1.1 : 0.9)
                                .animation(
                                    .easeInOut(duration: 2)
                                        .repeatForever(autoreverses: true),
                                    value: showContent
                                )

                            Text(suggestion.emoji)
                                .font(.system(size: 36))
                                .scaleEffect(showContent ? 1 : 0.8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(suggestion.name)
                                .font(.headline)
                                .fontWeight(.semibold)

                            HStack(spacing: 12) {
                                Label("\(suggestion.duration / 60)m", systemImage: "timer")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Text(suggestion.category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(Color("PrimaryColor").opacity(0.1))
                                    )
                            }
                        }

                        Spacer()

                        Button(action: addHabit) {
                            Image(systemName: "plus")
                                .fontWeight(.medium)
                        }
                        .buttonStyle(IconButtonStyle(
                            size: 44,
                            backgroundColor: Color("PrimaryColor")
                        ))
                        .disabled(isAdded)
                    }
                }
                .padding(4)
            }
            .transition(.asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            ))
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    showContent = true
                }
            }
            .onChange(of: suggestion.id) { _, _ in
                isAdded = false
                showContent = false
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    showContent = true
                }
            }
        }
    }

    private func addHabit() {
        guard let suggestion else { return }

        let habit = TemplateLibrary.shared.createHabit(from: suggestion)
        habit.sortOrder = habits.count
        context.insert(habit)

        do {
            try context.save()
            // Immediately refresh suggestion
            onAdd()
        } catch {
            print("Failed to save habit: \(error)")
        }
    }
}
