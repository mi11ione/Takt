import SwiftUI

struct OnboardingPermissionsView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @State private var wantsNotifications: Bool = true

    var body: some View {
        VStack(spacing: 16) {
            Text("onb_permissions_title").font(.title2).bold()
            Text("onb_permissions_desc").foregroundStyle(.secondary).multilineTextAlignment(.center)

            Toggle("onb_permissions_notifications", isOn: $wantsNotifications)
                .toggleStyle(.switch)

            NavigationLink("onb_continue") { OnboardingPaywallView() }
                .buttonStyle(PrimaryButtonStyle())

            Button("onb_skip") { hasOnboarded = true }
                .tint(.secondary)
        }
        .padding()
        .navigationTitle(Text("onb_permissions_nav"))
        .appBackground()
    }
}

#Preview { OnboardingPermissionsView() }
