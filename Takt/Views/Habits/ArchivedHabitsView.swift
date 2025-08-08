import SwiftData
import SwiftUI

struct ArchivedHabitsView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Habit> { $0.archivedAt != nil }, sort: [SortDescriptor(\Habit.createdAt, order: .reverse)])
    private var habits: [Habit]
    @State private var showContent = false
    @State private var isSelecting = false
    @State private var selectedIds: Set<UUID> = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if habits.isEmpty {
                    VStack(spacing: 20) {
                        Spacer(minLength: 100)

                        ZStack {
                            Circle()
                                .fill(Color("PrimaryColor").opacity(0.1))
                                .frame(width: 100, height: 100)
                                .blur(radius: 20)

                            Image(systemName: "archivebox")
                                .font(.system(size: 50))
                                .foregroundStyle(Color("PrimaryColor").opacity(0.5))
                        }

                        VStack(spacing: 8) {
                            Text("No Archived Habits")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)

                            Text("Archived habits will appear here")
                                .font(.body)
                                .foregroundStyle(.tertiary)
                        }

                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                } else {
                    // Header
                    VStack(spacing: 8) {
                        Text("\(habits.count)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text(habits.count == 1 ? "Archived Habit" : "Archived Habits")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            Button(isSelecting ? "Done" : "Select") { withAnimation { isSelecting.toggle(); if !isSelecting { selectedIds.removeAll() } } }
                                .buttonStyle(SecondaryButtonStyle(isCompact: true))
                            if isSelecting {
                                Button("Unarchive") {
                                    withAnimation { bulkUnarchive() }
                                }
                                .buttonStyle(BouncyButtonStyle())
                                Button(role: .destructive) { withAnimation { bulkDelete() } } label: { Text("Delete") }
                                    .buttonStyle(SecondaryButtonStyle())
                            }
                        }
                    }
                    .padding(.top, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)

                    // Archived habits list
                    ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
                        ArchivedHabitRow(habit: habit, isSelecting: isSelecting, isSelected: selectedIds.contains(habit.id)) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                unarchive(habit)
                            }
                        } onToggleSelect: {
                            if selectedIds.contains(habit.id) { selectedIds.remove(habit.id) } else { selectedIds.insert(habit.id) }
                        }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.8)
                                .delay(Double(index) * 0.05),
                            value: showContent
                        )
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle(Text("habits_archived_title"))
        .navigationBarTitleDisplayMode(.large)
        .background(AppBackground())
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    private func unarchive(_ habit: Habit) {
        habit.archivedAt = nil
        try? context.save()
    }

    private func bulkUnarchive() {
        for id in selectedIds {
            if let h = habits.first(where: { $0.id == id }) { h.archivedAt = nil }
        }
        selectedIds.removeAll()
        try? context.save()
    }

    private func bulkDelete() {
        for id in selectedIds {
            if let h = habits.first(where: { $0.id == id }) { context.delete(h) }
        }
        selectedIds.removeAll()
        try? context.save()
    }
}

struct ArchivedHabitRow: View {
    let habit: Habit
    let isSelecting: Bool
    let isSelected: Bool
    let onUnarchive: () -> Void
    let onToggleSelect: () -> Void
    @State private var isHovered = false

    var body: some View {
        Card(style: .glass) {
            HStack(spacing: 16) {
                // Emoji with muted appearance
                ZStack {
                    Circle()
                        .fill(Color("PrimaryColor").opacity(0.05))
                        .frame(width: 50, height: 50)

                    Text(habit.emoji)
                        .font(.title2)
                        .opacity(0.6)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.headline)
                        .foregroundStyle(.primary.opacity(0.8))

                    if let archivedAt = habit.archivedAt {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption2)
                            Text("Archived \(archivedAt.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if isSelecting {
                    Button(action: onToggleSelect) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button {
                        onUnarchive()
                    } label: {
                        Label("habits_unarchive", systemImage: "arrow.uturn.backward")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(IconButtonStyle(size: 36, backgroundColor: Color("PrimaryColor")))
                }
            }
        }
        .scaleEffect(isHovered ? 1.02 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview { ArchivedHabitsView() }
