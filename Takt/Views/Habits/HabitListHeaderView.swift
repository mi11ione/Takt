import SwiftUI

struct HabitListHeaderView: View {
    let recommended: Habit?
    let onStart: (Habit) -> Void
    @State private var isAnimating = false

    var body: some View {
        if let habit = recommended {
            ZStack {
                // Background gradient
                RoundedRectangle(cornerRadius: 24)
                    .fill(LinearGradient.primary.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(LinearGradient.primary.opacity(0.2), lineWidth: 1)
                    )

                HStack(spacing: 16) {
                    // Animated emoji container
                    ZStack {
                        Circle()
                            .fill(LinearGradient.primary.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .blur(radius: isAnimating ? 15 : 10)
                            .scaleEffect(isAnimating ? 1.2 : 1)

                        Text(habit.emoji)
                            .font(.largeTitle)
                            .scaleEffect(isAnimating ? 1.1 : 1)
                    }
                    .animation(
                        .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "sparkle")
                                .font(.caption2)
                                .foregroundStyle(Color("SecondaryColor"))
                            Text("header_recommended_title")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(Color("SecondaryColor"))
                                .textCase(.uppercase)
                        }
                        Text(habit.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                    }

                    Spacer()

                    NavigationLink("Browse") {
                        StarterTemplatesView()
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .frame(height: 90)
            .shadow(color: Color("PrimaryColor").opacity(0.07), radius: 6, y: 3)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

#Preview {
    HabitListHeaderView(recommended: nil, onStart: { _ in })
}
