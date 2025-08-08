import SwiftData
import SwiftUI

struct StartChainView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let chain: Chain
    let startAt: Int?

    @State private var currentIndex: Int = 0
    @State private var isComplete: Bool = false
    @State private var showContent = false

    init(chain: Chain, startAt: Int? = nil) {
        self.chain = chain
        self.startAt = startAt
    }

    var body: some View {
        ZStack {
            AnimatedMeshBackground()
            
            if isComplete {
                // Completion view
                VStack(spacing: 32) {
                    Spacer()
                    
                    ZStack {
                        ForEach(0..<3) { index in
                            Circle()
                                .stroke(
                                    LinearGradient.success.opacity(0.3 - Double(index) * 0.1),
                                    lineWidth: 2
                                )
                                .frame(width: 120 + CGFloat(index * 40), height: 120 + CGFloat(index * 40))
                                .scaleEffect(showContent ? 1.2 : 0.8)
                                .opacity(showContent ? 0 : 1)
                                .animation(
                                    .easeOut(duration: 1.5)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.2),
                                    value: showContent
                                )
                        }
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("Success"), Color("PrimaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(showContent ? 1 : 0.5)
                            .rotationEffect(.degrees(showContent ? 0 : -180))
                    }
                    
                    VStack(spacing: 16) {
                        Text("Chain Complete!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("chain_complete_message")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BouncyButtonStyle())
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
                .transition(.asymmetric(
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 1.1).combined(with: .opacity)
                ))
                .sensoryFeedback(.success, trigger: isComplete)
                
            } else if let step = stepHabit {
                // Active chain view
                VStack(spacing: 32) {
                    // Progress indicator
                    ChainProgressView(
                        currentIndex: currentIndex,
                        totalSteps: orderedHabits.count
                    )
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Current habit
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient.primary.opacity(0.15))
                                .frame(width: 140, height: 140)
                                .blur(radius: 30)
                            
                            Text(step.emoji)
                                .font(.system(size: 80))
                                .scaleEffect(showContent ? 1 : 0.5)
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .id(step.id)
                        
                        VStack(spacing: 8) {
                            Text(step.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            if step.defaultDurationSeconds > 0 {
                                Label(
                                    "\(step.defaultDurationSeconds / 60) min",
                                    systemImage: "timer"
                                )
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Action buttons
                    HStack(spacing: 16) {
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                next()
                            }
                        } label: {
                            Label("chain_skip", systemImage: "forward.fill")
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                log(step)
                            }
                        } label: {
                            Label("chain_log", systemImage: "checkmark")
                                .frame(width: 120)
                        }
                        .buttonStyle(BouncyButtonStyle())
                    }
                    .padding(.bottom, 50)
                }
                .padding(.horizontal)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
            } else {
                ContentUnavailableView("chains_unavailable", systemImage: "link.badge.plus")
                    .transition(.opacity)
            }
        }
        .ignoresSafeArea()
        .navigationTitle(Text(chain.name))
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentIndex)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isComplete)
        .onAppear {
            if let startAt, startAt >= 0 { currentIndex = startAt }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }

    private var orderedHabits: [Habit] {
        chain.items.sorted { $0.order < $1.order }.compactMap(\.habit)
    }

    private var stepHabit: Habit? { orderedHabits[safe: currentIndex] }

    private func next() {
        let nextIndex = currentIndex + 1
        if nextIndex >= orderedHabits.count { isComplete = true } else { currentIndex = nextIndex }
    }

    private func log(_ habit: Habit) {
        let entry = HabitEntry(performedAt: .now, durationSeconds: habit.defaultDurationSeconds, habit: habit)
        context.insert(entry)
        try? context.save()
        next()
    }
}

struct ChainProgressView: View {
    let currentIndex: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                circleFill(index: index)
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.5 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentIndex)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func circleFill(index: Int) -> some View {
        if index <= currentIndex {
            Circle().fill(LinearGradient.primary)
        } else {
            Circle().fill(Color("PrimaryColor").opacity(0.2))
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}

#Preview { StartChainView(chain: Chain(name: "Focus Reset"), startAt: 0) }
