// Favorites Grid Widget – add to Widget Extension target membership.
import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct FavoritesGridEntry: TimelineEntry { let date: Date; let items: [HabitEntity] }

struct FavoritesGridProvider: TimelineProvider {
    func placeholder(in context: Context) -> FavoritesGridEntry {
        FavoritesGridEntry(date: .now, items: [HabitEntity(id: UUID(), name: "Hydrate", emoji: "💧"), HabitEntity(id: UUID(), name: "Stretch", emoji: "🧘")])
    }
    func getSnapshot(in context: Context, completion: @escaping (FavoritesGridEntry) -> Void) {
        completion(placeholder(in: context))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<FavoritesGridEntry>) -> Void) {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let model = ModelContext(container)
            let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.archivedAt == nil && $0.isFavorite == true })
            let habits = (try? model.fetch(descriptor)) ?? []
            let items = habits.prefix(8).map { HabitEntity(id: $0.id, name: $0.name, emoji: $0.emoji) }
            let entry = FavoritesGridEntry(date: .now, items: Array(items))
            let next = Calendar.autoupdatingCurrent.date(byAdding: .hour, value: 1, to: .now) ?? .now.addingTimeInterval(3600)
            completion(Timeline(entries: [entry], policy: .after(next)))
        } catch {
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
        }
    }
}

struct FavoritesGridWidgetView: View {
    let entry: FavoritesGridEntry
    var body: some View {
        let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(entry.items, id: \.id) { item in
                Link(destination: URL(string: "takt://start-timer?id=\(item.id.uuidString)")!) {
                    VStack(spacing: 4) {
                        Text(item.emoji)
                        Text(item.name).font(.caption2).lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(6)
                    .background(Color("Card"))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("Border"), lineWidth: 1))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .containerBackground(for: .widget) {
            Color("Card")
        }
    }
}

struct FavoritesGridWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "takt.favorites.grid", provider: FavoritesGridProvider()) { entry in
            FavoritesGridWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_favorites_title")
        .description("widget_favorites_desc")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    FavoritesGridWidget()
} timeline: {
    FavoritesGridEntry(date: .now, items: [HabitEntity(id: UUID(), name: "Hydrate", emoji: "💧"), HabitEntity(id: UUID(), name: "Stretch", emoji: "🧘")])
}


