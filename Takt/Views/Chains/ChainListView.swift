import SwiftData
import SwiftUI

struct ChainListView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<Chain> { $0.archivedAt == nil }, sort: [SortDescriptor(\Chain.createdAt, order: .reverse)])
    private var chains: [Chain]

    @State private var showEditor: Bool = false
    @State private var editingChain: Chain?
    @State private var showContent = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if chains.isEmpty {
                    VStack(spacing: 20) {
                        Spacer(minLength: 100)

                        ZStack {
                            Circle()
                                .fill(LinearGradient.primary.opacity(0.15))
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)

                            Image(systemName: "link.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(LinearGradient.primary)
                                .symbolEffect(.pulse)
                        }

                        VStack(spacing: 8) {
                            Text("chains_empty_title")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("chains_empty_desc")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Button("chains_add_first") {
                            editingChain = nil
                            showEditor = true
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .padding(.top, 10)

                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                } else {
                    ForEach(Array(chains.enumerated()), id: \.element.id) { index, chain in
                        NavigationLink(destination: StartChainView(chain: chain)) {
                            ChainCard(chain: chain)
                                .contextMenu {
                                    Button {
                                        editingChain = chain
                                        showEditor = true
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            archive(chain)
                                        }
                                    } label: {
                                        Label("Archive", systemImage: "archivebox")
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.8)
                                .delay(Double(index) * 0.1),
                            value: showContent
                        )
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle(Text("chains_title"))
        .navigationBarTitleDisplayMode(.large)
        .background(AppBackground())
        .overlay(alignment: .bottomTrailing) {
            if !chains.isEmpty {
                FloatingActionButton(icon: "plus") {
                    editingChain = nil
                    showEditor = true
                }
                .padding(20)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack { ChainEditorView(chain: editingChain) }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    private func archive(_ chain: Chain) {
        chain.archivedAt = .now
        try? context.save()
    }
}

struct ChainCard: View {
    let chain: Chain
    @State private var isHovered = false

    var body: some View {
        Card(style: .glass) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(chain.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                // Preview of chain items
                HStack(spacing: 8) {
                    ForEach(chain.items.sorted(by: { $0.order < $1.order }).prefix(4), id: \.id) { item in
                        if let habit = item.habit {
                            ZStack {
                                Circle()
                                    .fill(Color("PrimaryColor").opacity(0.1))
                                    .frame(width: 40, height: 40)

                                Text(habit.emoji)
                                    .font(.title3)
                            }
                        }
                    }

                    if chain.items.count > 4 {
                        ZStack {
                            Circle()
                                .fill(Color("SecondaryColor").opacity(0.1))
                                .frame(width: 40, height: 40)

                            Text("+\(chain.items.count - 4)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(Color("SecondaryColor"))
                        }
                    }

                    Spacer()
                }
                HStack {
                    Label("\(chain.items.count) habits", systemImage: "link")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    let totalDuration = chain.items.compactMap { $0.habit?.defaultDurationSeconds }.reduce(0, +)
                    if totalDuration > 0 {
                        Label("\(totalDuration / 60) min", systemImage: "timer")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
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

#Preview { NavigationStack { ChainListView() } }
