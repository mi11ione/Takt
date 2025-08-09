// Chain Progress Widget – add to Widget Extension target membership.
import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct ChainProgressEntry: TimelineEntry { let date: Date; let name: String; let next: HabitEntity? }

struct ChainProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> ChainProgressEntry {
        .init(date: .now, name: "Morning Flow", next: HabitEntity(id: UUID(), name: "Hydrate", emoji: "💧"))
    }
    func getSnapshot(in context: Context, completion: @escaping (ChainProgressEntry) -> Void) { completion(placeholder(in: context)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<ChainProgressEntry>) -> Void) {
        do {
            let container = try ModelContainerFactory.makeSharedContainer()
            let model = ModelContext(container)
            let chains = (try? model.fetch(FetchDescriptor<Chain>(predicate: #Predicate { $0.archivedAt == nil }))) ?? []
            guard let chain = chains.first else {
                completion(Timeline(entries: [ChainProgressEntry(date: .now, name: "No Chain", next: nil)], policy: .atEnd))
                return
            }
            let nextHabit = chain.items.sorted(by: { $0.order < $1.order }).first?.habit
            let nextEntity = nextHabit.map { HabitEntity(id: $0.id, name: $0.name, emoji: $0.emoji) }
            let entry = ChainProgressEntry(date: .now, name: chain.name, next: nextEntity)
            let nextRefresh = Calendar.autoupdatingCurrent.date(byAdding: .hour, value: 1, to: .now) ?? .now.addingTimeInterval(3600)
            completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
        } catch {
            completion(Timeline(entries: [placeholder(in: context)], policy: .atEnd))
        }
    }
}

struct ChainProgressWidgetView: View {
    let entry: ChainProgressEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.name).font(.headline)
                Spacer()
            }
            if let next = entry.next {
                HStack {
                    Text(next.emoji)
                    Text(next.name)
                }
                Link(destination: URL(string: "takt://start-timer?id=\(next.id.uuidString)")!) { Label("Start", systemImage: "play.fill") }
                .buttonStyle(.borderedProminent)
            } else {
                Text("No next step").foregroundStyle(Color("OnSurfaceSecondary"))
            }
        }
        .padding(12)
        .containerBackground(for: .widget) {
            Color("Card")
        }
    }
}

struct ChainProgressWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "takt.chain.progress", provider: ChainProgressProvider()) { entry in
            ChainProgressWidgetView(entry: entry)
        }
        .configurationDisplayName("widget_chain_title")
        .description("widget_chain_desc")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) { ChainProgressWidget() } timeline: {
    ChainProgressEntry(date: .now, name: "Morning Flow", next: HabitEntity(id: UUID(), name: "Hydrate", emoji: "💧"))
}


