import SwiftUI

struct OnboardingPaywallView: View {
    @Environment(\.subscriptionManager) private var subscriptions
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var isProcessing: Bool = false
    @State private var showContent = false
    @State private var animateCrown = false

    var body: some View {
        ZStack {
            AnimatedMeshBackground()

            ScrollView {
                VStack(spacing: 32) {
                    // Premium crown animation
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color("Warning").opacity(0.3),
                                        Color("Warning").opacity(0.1),
                                        Color.clear,
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 160, height: 160)
                            .blur(radius: animateCrown ? 20 : 15)
                            .scaleEffect(animateCrown ? 1.2 : 1)

                        Image(systemName: "crown.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("Warning"), Color("SecondaryColor")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .rotationEffect(.degrees(animateCrown ? -5 : 5))
                            .shimmer()
                    }
                    .animation(
                        .easeInOut(duration: 3)
                            .repeatForever(autoreverses: true),
                        value: animateCrown
                    )
                    .padding(.top, 40)

                    VStack(spacing: 16) {
                        Text("Unlock Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Get unlimited habits and advanced features")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)

                    // Feature cards
                    VStack(spacing: 12) {
                        FeatureCard(
                            icon: "infinity",
                            title: "Unlimited Habits",
                            description: "Track as many habits as you want",
                            color: Color("PrimaryColor")
                        )

                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Advanced Analytics",
                            description: "Deep insights into your progress",
                            color: Color("Success")
                        )

                        FeatureCard(
                            icon: "bell.badge",
                            title: "Smart Reminders",
                            description: "AI-powered notification timing",
                            color: Color("SecondaryColor")
                        )
                    }
                    .padding(.horizontal)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)

                    // Price options
                    PaywallView()
                        .background(Color.clear)
                        .opacity(showContent ? 1 : 0)
                        .scaleEffect(showContent ? 1 : 0.9)

                    // Action buttons
                    VStack(spacing: 16) {
                        Button("onb_paywall_subscribe") {
                            isProcessing = true
                            Task { defer { isProcessing = false }
                                try? await subscriptions.purchasePremium()
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    hasOnboarded = true
                                }
                            }
                        }
                        .buttonStyle(BouncyButtonStyle())
                        .overlay(
                            isProcessing ?
                                ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                                : nil
                        )
                        .disabled(isProcessing)

                        Button("onb_paywall_continue_free") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                hasOnboarded = true
                            }
                        }
                        .buttonStyle(GlassButtonStyle())

                        Button("onb_paywall_restore") {
                            Task { try? await subscriptions.restorePurchases() }
                        }
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)
                }
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: showContent)
        .onAppear {
            animateCrown = true
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        Card(style: .glass) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
    }
}

#Preview { OnboardingPaywallView() }
