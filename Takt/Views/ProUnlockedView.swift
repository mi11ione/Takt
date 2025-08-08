import SwiftUI

struct ProUnlockedView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    @State private var animateCrown = false
    @State private var showParticles = false

    var body: some View {
        ZStack {
            // Animated background
            AnimatedMeshBackground()

            // Celebration particles
            if showParticles {
                ParticleEffect()
                    .allowsHitTesting(false)
            }

            VStack(spacing: 32) {
                Spacer()

                // Success animation
                ZStack {
                    // Glowing rings
                    ForEach(0 ..< 3) { index in
                        Circle()
                            .stroke(
                                LinearGradient.primary.opacity(0.3 - Double(index) * 0.1),
                                lineWidth: 2
                            )
                            .frame(width: 150 + CGFloat(index * 50), height: 150 + CGFloat(index * 50))
                            .scaleEffect(animateCrown ? 1.1 : 0.9)
                            .opacity(animateCrown ? 0 : 1)
                            .animation(
                                .easeOut(duration: 2)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.3),
                                value: animateCrown
                            )
                    }

                    // Crown icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color("Warning").opacity(0.5),
                                        Color("Warning").opacity(0.2),
                                        Color.clear,
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .blur(radius: 30)

                        Image(systemName: "crown.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("Warning"), Color("SecondaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .scaleEffect(showContent ? 1 : 0.5)
                            .rotationEffect(.degrees(showContent ? 0 : -30))
                            .shimmer()
                    }
                }

                // Success message
                VStack(spacing: 16) {
                    Text("Welcome to Pro!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("You now have unlimited access to all features")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                // Features unlocked
                VStack(spacing: 12) {
                    FeatureUnlockedRow(
                        icon: "infinity",
                        title: "Unlimited Habits",
                        delay: 0.2
                    )

                    FeatureUnlockedRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Advanced Analytics",
                        delay: 0.3
                    )

                    FeatureUnlockedRow(
                        icon: "bell.badge",
                        title: "Smart Reminders",
                        delay: 0.4
                    )

                    FeatureUnlockedRow(
                        icon: "sparkles",
                        title: "AI Insights",
                        delay: 0.5
                    )
                }
                .padding(.horizontal)

                Spacer()

                // Continue button
                Button {
                    dismiss()
                } label: {
                    Text("Start Building Habits")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(BouncyButtonStyle())
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
            }
            .padding()
        }
        .ignoresSafeArea()
        .sensoryFeedback(.success, trigger: showContent)
        .onAppear {
            animateCrown = true
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                showParticles = true
            }
        }
    }
}

struct FeatureUnlockedRow: View {
    let icon: String
    let title: String
    let delay: Double
    @State private var isVisible = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color("Success").opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(Color("Success"))
            }

            Text(title)
                .font(.body)
                .fontWeight(.medium)

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color("Success"))
                .transition(.scale.combined(with: .opacity))
        }
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                isVisible = true
            }
        }
    }
}

#Preview { ProUnlockedView() }
