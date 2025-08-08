import SwiftData
import SwiftUI

struct StarterTemplatesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var addedTemplates: Set<UUID> = []

    struct Template: Identifiable {
        let id = UUID()
        let name: String
        let emoji: String
        let duration: Int
        let blurb: LocalizedStringKey
        let category: String
        let gradient: LinearGradient
    }

    private var templates: [Template] = [
        // Health & Wellness
        .init(name: "Water Break", emoji: "💧", duration: 30, blurb: "template_water_blurb", category: "Health", gradient: .success),
        .init(name: "Desk Stretch", emoji: "🧘", duration: 60, blurb: "template_stretch_blurb", category: "Health", gradient: .success),
        .init(name: "Deep Breathing", emoji: "🌬️", duration: 90, blurb: "Take a moment to breathe deeply", category: "Health", gradient: .success),
        .init(name: "Walk Break", emoji: "🚶", duration: 300, blurb: "Get up and move around", category: "Health", gradient: .success),
        
        // Productivity
        .init(name: "Inbox Skim", emoji: "📬", duration: 90, blurb: "template_inbox_blurb", category: "Productivity", gradient: .primary),
        .init(name: "Daily Planning", emoji: "📅", duration: 300, blurb: "Plan your day for success", category: "Productivity", gradient: .primary),
        .init(name: "Code Review", emoji: "💻", duration: 900, blurb: "Review and refactor code", category: "Productivity", gradient: .primary),
        .init(name: "Quick Tidy", emoji: "🧹", duration: 180, blurb: "Clean your workspace", category: "Productivity", gradient: .primary),
        
        // Mindfulness
        .init(name: "Meditation", emoji: "🧘‍♀️", duration: 600, blurb: "Center yourself with meditation", category: "Mindfulness", gradient: .mesh),
        .init(name: "Gratitude", emoji: "🙏", duration: 180, blurb: "Reflect on what you're grateful for", category: "Mindfulness", gradient: .mesh),
        .init(name: "Journal", emoji: "📝", duration: 300, blurb: "Write down your thoughts", category: "Mindfulness", gradient: .mesh),
        
        // Creativity
        .init(name: "Sketch", emoji: "✏️", duration: 600, blurb: "Draw or doodle freely", category: "Creativity", gradient: .warning),
        .init(name: "Music Practice", emoji: "🎸", duration: 1800, blurb: "Practice your instrument", category: "Creativity", gradient: .warning),
        .init(name: "Creative Writing", emoji: "✍️", duration: 900, blurb: "Write creatively", category: "Creativity", gradient: .warning),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundStyle(LinearGradient.primary)
                            .symbolEffect(.variableColor.iterative.reversing)
                        
                        Text("Start with proven habits")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Select templates to add to your habit list")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : -20)
                    
                    // Categories
                    let categories = Dictionary(grouping: templates) { $0.category }
                    ForEach(Array(categories.keys).sorted(), id: \.self) { category in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(category)
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(categories[category] ?? []) { template in
                                        TemplateCard(
                                            template: template,
                                            isAdded: addedTemplates.contains(template.id)
                                        ) {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                                add(template)
                                            }
                                        }
                                        .opacity(showContent ? 1 : 0)
                                        .scaleEffect(showContent ? 1 : 0.8)
                                        .animation(
                                            .spring(response: 0.8, dampingFraction: 0.8)
                                            .delay(Double(templates.firstIndex(where: { $0.id == template.id }) ?? 0) * 0.05),
                                            value: showContent
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            .navigationTitle(Text("templates_title"))
            .navigationBarTitleDisplayMode(.inline)
            .background(AppBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color("PrimaryColor"))
                        .fontWeight(.medium)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                    showContent = true
                }
            }
        }
    }

    private func add(_ t: Template) {
        let habit = Habit(name: t.name, emoji: t.emoji, defaultDurationSeconds: t.duration)
        context.insert(habit)
        try? context.save()
        addedTemplates.insert(t.id)
    }
}

struct TemplateCard: View {
    let template: StarterTemplatesView.Template
    let isAdded: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(template.gradient.opacity(0.12))
                        .frame(width: 80, height: 80)
                    
                    Text(template.emoji)
                        .font(.system(size: 40))
                }
                
                VStack(spacing: 4) {
                    Text(template.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .font(.caption2)
                        Text("\(template.duration / 60)m")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
                
                ZStack {
                    if isAdded {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color("Success"))
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(template.gradient)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 30)
            }
            .frame(width: 140, height: 200)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.thinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                Color("Success").opacity(isAdded ? 0.45 : 0.0),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: Color("PrimaryColor").opacity(0.07), radius: 6, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isAdded)
        .scaleEffect(isAdded ? 0.9 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isAdded)
    }
}

#Preview { StarterTemplatesView() }
