import SwiftUI

/// Paywall baseline (tiers policy):
/// - $4.99/month, $24.99/year (annual‑first), no trial. Annual ~35% discount.
/// - Upgrade/downgrade within a single subscription group.
struct PaywallView: View {
    @Environment(\.subscriptionManager) private var subscriptions
    @State private var selectedPlan: PricingPlan = .annual
    @State private var showContent = false

    enum PricingPlan {
        case monthly, annual
    }

    var body: some View {
        VStack(spacing: 20) {
            // Title section with sharp call-to-action symbol
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(LinearGradient.primary.opacity(0.15))
                        .frame(width: 68, height: 68)
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(LinearGradient.primary)
                        .symbolEffect(.bounce.down, value: showContent)
                        .shadow(color: Color("PrimaryColor").opacity(0.2), radius: 6, y: 3)
                }

                Text("paywall_title")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(LinearGradient(
                        colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))

                Text("paywall_subtitle")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("OnSurfaceSecondary"))
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : -20)

            // Benefits
            VStack(spacing: 10) {
                BenefitRow(
                    icon: "bolt.fill",
                    title: "paywall_benefit_speed",
                    color: Color("Warning")
                )

                BenefitRow(
                    icon: "flame.fill",
                    title: "paywall_benefit_streaks",
                    color: Color("SecondaryColor")
                )

                BenefitRow(
                    icon: "chart.bar.fill",
                    title: "paywall_benefit_analytics",
                    color: Color("Success")
                )
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            // Pricing cards
            VStack(spacing: 14) {
                // Annual plan
                PricingCard(
                    isSelected: selectedPlan == .annual,
                    title: "Annual",
                    price: "$24.99",
                    period: "per year",
                    savings: "Save 58%",
                    isRecommended: true
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedPlan = .annual
                    }
                }

                // Monthly plan
                PricingCard(
                    isSelected: selectedPlan == .monthly,
                    title: "Monthly",
                    price: "$4.99",
                    period: "per month",
                    savings: nil,
                    isRecommended: false
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedPlan = .monthly
                    }
                }
            }
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.95)

            // Restore + Legal
            VStack(spacing: 10) {
                Button("settings_restore_purchases") {
                    Task { try? await subscriptions.restorePurchases() }
                }
                .font(.footnote)
                .foregroundStyle(Color("OnSurfaceSecondary"))

                HStack(spacing: 12) {
                    Link(destination: URL(string: "https://takt.app/privacy")!) {
                        Text("settings_privacy_policy")
                    }
                    .font(.footnote)
                    .foregroundStyle(Color("OnSurfaceSecondary"))

                    Text("|").foregroundStyle(Color("OnSurfaceSecondary"))

                    Link(destination: URL(string: "https://takt.app/terms")!) {
                        Text("settings_terms")
                    }
                    .font(.footnote)
                    .foregroundStyle(Color("OnSurfaceSecondary"))
                }
            }
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

struct BenefitRow: View {
    let icon: String
    let title: LocalizedStringKey
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.body)
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.body)
                .foregroundStyle(.primary)

            Spacer()
        }
    }
}

struct PricingCard: View {
    let isSelected: Bool
    let title: String
    let price: String
    let period: String
    let savings: String?
    let isRecommended: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Card(style: isSelected ? .gradient : .glass) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(Color.primary)

                            HStack(spacing: 4) {
                                Text(price)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primary)

                                Text(period)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.primary)
                            }

                            if let savings {
                                Text(savings)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule()
                                            .fill(isSelected ? .white.opacity(0.16) : Color("Success").opacity(0.12))
                                    )
                                    .foregroundStyle(Color("Success"))
                            }
                        }

                        Spacer()

                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(isSelected ? .white : Color("PrimaryColor"))
                    }
                }

                if isRecommended {
                    Text("BEST VALUE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(LinearGradient.warning)
                        )
                        .foregroundStyle(Color("OnEmphasis"))
                        .offset(x: -10, y: -10)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview { PaywallView() }
