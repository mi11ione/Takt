import SwiftData
import SwiftUI

struct ChainListView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Chain> { $0.archivedAt == nil }, sort: [SortDescriptor(\Chain.createdAt, order: .reverse)])
    private var chains: [Chain]

    @State private var showEditor: Bool = false
    @State private var editingChain: Chain?

    var body: some View {
        List {
            if chains.isEmpty {
                ContentUnavailableView {
                    Label("chains_empty_title", systemImage: "link")
                } description: {
                    Text("chains_empty_desc")
                } actions: {
                    Button("chains_add_first") { editingChain = nil; showEditor = true }
                        .buttonStyle(HapticButtonStyle())
                }
            } else {
                ForEach(chains, id: \.id) { chain in
                    NavigationLink(destination: ChainEditorView(chain: chain)) {
                        VStack(alignment: .leading) {
                            Text(chain.name).font(.headline)
                            Text("\(chain.items.count) items").font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions { Button(role: .destructive) { archive(chain) } label: { Label("Archive", systemImage: "archivebox") } }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .appBackground()
        .navigationTitle(Text("chains_title"))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { editingChain = nil; showEditor = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack { ChainEditorView(chain: editingChain) }
        }
    }

    private func archive(_ chain: Chain) {
        chain.archivedAt = .now
        try? context.save()
    }
}

#Preview { NavigationStack { ChainListView() } }
