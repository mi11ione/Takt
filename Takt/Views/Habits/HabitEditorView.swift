import SwiftData
import SwiftUI

struct HabitEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var habit: Habit?

    @State private var name: String = ""
    @State private var emoji: String = "🔥"
    @State private var duration: Double = 60
    @State private var isFavorite: Bool = false
    @State private var showEmojiPicker = false
    @State private var showContent = false

    let emojiOptions = ["🔥", "💪", "📚", "🧘", "💻", "🎨", "🏃", "💧", "🌱", "✨", "🎯", "🧠", "💡", "🌟", "🚀", "📝", "🎸", "🍎", "😴", "🏋️"]

    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedMeshBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        emojiSelectorSection
                        formFieldsSection
                    }
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea()
            .navigationTitle(Text(habit == nil ? "habiteditor_new_title" : "habiteditor_edit_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            .onAppear {
                if let habit { load(habit) }
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                    showContent = true
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var emojiSelectorSection: some View {
        VStack(spacing: 16) {
            emojiDisplay
            
            if showEmojiPicker {
                emojiPickerGrid
            }
        }
        .padding(.top, 40)
    }
    
    private var emojiDisplay: some View {
        Text(emoji)
            .font(.system(size: 80))
            .scaleEffect(showContent ? 1 : 0.5)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showContent)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showEmojiPicker.toggle()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                editIndicator
            }
    }
    
    private var editIndicator: some View {
        Circle()
            .fill(LinearGradient.primary)
            .frame(width: 30, height: 30)
            .overlay(
                Image(systemName: "pencil")
                    .font(.caption)
                    .foregroundStyle(Color("OnEmphasis"))
            )
            .offset(x: 5, y: 5)
    }
    
    private var emojiPickerGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
            ForEach(emojiOptions, id: \.self) { option in
                emojiOption(option)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            emoji = option
                            showEmojiPicker = false
                        }
                    }
            }
        }
        .padding()
        .background(Card(style: .glass) { Color.clear })
        .transition(.scale.combined(with: .opacity))
    }
    
    private func emojiOption(_ option: String) -> some View {
        Text(option)
            .font(.largeTitle)
            .scaleEffect(emoji == option ? 1.2 : 1)
            .padding(8)
            .background(
                Circle()
                    .fill(emoji == option ? LinearGradient.primary.opacity(0.2) : LinearGradient.primary.opacity(0.0))
            )
    }
    
    private var formFieldsSection: some View {
        VStack(spacing: 20) {
            nameField
            durationSelector
            favoriteToggle
        }
        .padding(.horizontal)
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
    }
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("habiteditor_basics", systemImage: "pencil.circle.fill")
                .font(.headline)
                .foregroundStyle(Color("PrimaryColor"))
            
            Card(style: .glass) {
                TextField("habiteditor_name_placeholder", text: $name)
                    .font(.title3)
                    .padding(.vertical, 4)
            }
        }
    }
    
    private var durationSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Duration", systemImage: "timer")
                .font(.headline)
                .foregroundStyle(Color("PrimaryColor"))
            
            Card(style: .glass) {
                HStack(spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if duration > 30 { duration -= 30 }
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color("SecondaryColor"))
                    }

                    Spacer()

                        Text("\(Int(duration))")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())

                    Spacer()

                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if duration < 3600 { duration += 30 }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                }
            }
        }
    }
    
    private var durationText: some View { EmptyView() }
    private var durationControls: some View { EmptyView() }
    
    private var favoriteToggle: some View {
        Card(style: .glass) {
            HStack {
                Label("habiteditor_favorite", systemImage: isFavorite ? "star.fill" : "star")
                    .foregroundStyle(isFavorite ? Color("Warning") : .primary)
                
                Spacer()
                
                Toggle("", isOn: $isFavorite.animation(.spring(response: 0.3, dampingFraction: 0.7)))
                    .labelsHidden()
                    .tint(Color("Warning"))
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("common_cancel") { dismiss() }
                .foregroundStyle(Color("SecondaryColor"))
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button("common_save") { save() }
                .bold()
                .foregroundStyle(Color("PrimaryColor"))
                .disabled(name.isEmpty)
        }
    }

    private func load(_ habit: Habit) {
        name = habit.name
        emoji = habit.emoji
        duration = Double(habit.defaultDurationSeconds)
        isFavorite = habit.isFavorite
    }

    private func save() {
        if let habit {
            habit.name = name
            habit.emoji = emoji
            habit.defaultDurationSeconds = Int(duration)
            habit.isFavorite = isFavorite
        } else {
            let newHabit = Habit(name: name, emoji: emoji, isFavorite: isFavorite, defaultDurationSeconds: Int(duration))
            context.insert(newHabit)
        }
        try? context.save()
        dismiss()
    }
}

#Preview { HabitEditorView(habit: nil) }
