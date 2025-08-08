import SwiftUI

struct OnboardingIntroView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bolt.heart.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)

                Text("onb_intro_title")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)

                Text("onb_intro_subtitle")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                NavigationLink("onb_continue") { OnboardingPermissionsView() }
                    .buttonStyle(PrimaryButtonStyle())

                Button("onb_skip") {
                    hasOnboarded = true
                }
                .tint(.secondary)
            }
            .padding()
        }
        .appBackground()
        .sensoryFeedback(.success, trigger: hasOnboarded)
    }
}

#Preview {
    OnboardingIntroView()
}
