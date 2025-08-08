import SwiftUI

struct OnboardingPaywallView: View {
    @Environment(\.subscriptionManager) private var subscriptions
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            PaywallView()

            HStack(spacing: 12) {
                Button("onb_paywall_continue_free") { hasOnboarded = true }
                    .buttonStyle(HapticButtonStyle())
                    .buttonBorderShape(.roundedRectangle)

                Button("onb_paywall_subscribe") {
                    isProcessing = true
                    Task { defer { isProcessing = false }
                        try? await subscriptions.purchasePremium()
                        hasOnboarded = true
                    }
                }
                .buttonStyle(HapticButtonStyle())
                .buttonBorderShape(.roundedRectangle)
            }

            Button("onb_paywall_restore") {
                Task { try? await subscriptions.restorePurchases() }
            }
            .tint(.secondary)
        }
        .padding()
        .navigationTitle(Text("onb_paywall_nav"))
        .disabled(isProcessing)
    }
}

#Preview { OnboardingPaywallView() }
