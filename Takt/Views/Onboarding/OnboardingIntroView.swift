import SwiftUI

struct OnboardingIntroView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var isAnimating = false
    @State private var showContent = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Animated background
                AnimatedMeshBackground()

                // Floating particles
                ParticleEffect()
                    .allowsHitTesting(false)
                    .opacity(0.6)

                VStack(spacing: 32) {
                    Spacer()

                    // Animated logo
                    ZStack {
                        Circle()
                            .fill(LinearGradient.primary.opacity(0.2))
                            .frame(width: 150, height: 150)
                            .blur(radius: isAnimating ? 30 : 20)
                            .scaleEffect(isAnimating ? 1.3 : 1)

                        Circle()
                            .fill(LinearGradient.primary.opacity(0.1))
                            .frame(width: 200, height: 200)
                            .blur(radius: isAnimating ? 40 : 30)
                            .scaleEffect(isAnimating ? 1.1 : 0.9)

                        Image(systemName: "bolt.heart.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(LinearGradient.primary)
                            .symbolEffect(.bounce.up, value: showContent)
                            .scaleEffect(showContent ? 1 : 0.5)
                    }
                    .animation(
                        .easeInOut(duration: 3)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                    VStack(spacing: 16) {
                        Text("onb_intro_title")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)

                        Text("onb_intro_subtitle")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                    }
                    .padding(.horizontal)

                    Spacer()

                    VStack(spacing: 16) {
                        NavigationLink("onb_continue") {
                            OnboardingPermissionsView()
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.8)

                        Button("onb_skip") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                hasOnboarded = true
                            }
                        }
                        .buttonStyle(GlassButtonStyle())
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: showContent)
            }
            .ignoresSafeArea()
        }
        .sensoryFeedback(.success, trigger: hasOnboarded)
        .onAppear {
            isAnimating = true
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5)) {
                showContent = true
            }
        }
    }
}

#Preview {
    OnboardingIntroView()
}
