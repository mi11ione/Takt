import SwiftUI

/// Paywall baseline (tiers policy):
/// - $4.99/month, $24.99/year (annual‑first), no trial. Annual ~35% discount.
/// - Upgrade/downgrade within a single subscription group.
struct PaywallView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("paywall_title").font(.largeTitle).bold()
            Text("paywall_subtitle").multilineTextAlignment(.center).foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Label("paywall_benefit_speed", systemImage: "bolt.fill")
                Label("paywall_benefit_streaks", systemImage: "flame.fill")
                Label("paywall_benefit_analytics", systemImage: "chart.bar.fill")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.quaternary, in: .rect(cornerRadius: 12))

            Text("paywall_pricing_annual").font(.headline)
            Text("paywall_pricing_monthly").font(.subheadline).foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview { PaywallView() }
