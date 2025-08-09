import SwiftUI

struct OnboardingPermissionsView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @Environment(\.notificationScheduler) private var scheduler
    @AppStorage("notificationsEnabled") private var wantsNotifications: Bool = false
    @State private var showContent = false
    @State private var animateIcon = false

    var body: some View {
        ZStack {
            AnimatedMeshBackground()

            VStack(spacing: 32) {
                Spacer()

                // Animated notification icon
                ZStack {
                    Circle()
                        .fill(LinearGradient.primary.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .blur(radius: animateIcon ? 25 : 15)
                        .scaleEffect(animateIcon ? 1.2 : 1)

                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(LinearGradient.primary)
                        .symbolEffect(.bounce.up, value: showContent)
                        .rotationEffect(.degrees(animateIcon ? -10 : 10))
                }
                .animation(
                    .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true),
                    value: animateIcon
                )

                VStack(spacing: 16) {
                    Text("onb_permissions_title")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color("PrimaryColor"), Color("SecondaryColor")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("onb_permissions_desc")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                // Permission card
                Card(style: .glass) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("PrimaryColor").opacity(0.1))
                                .frame(width: 50, height: 50)
                            Image(systemName: "bell.fill")
                                .font(.title2)
                                .foregroundStyle(Color("PrimaryColor"))
                        }

                        VStack(alignment: .leading) {
                            Text("onb_permissions_notifications")
                                .font(.headline)
                            Text("Stay on track with reminders")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Toggle("", isOn: $wantsNotifications)
                            .labelsHidden()
                            .tint(Color("PrimaryColor"))
                    }
                }
                .padding(.horizontal)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink("onb_continue") {
                        PaywallView()
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        Task {
                            if wantsNotifications { _ = await scheduler.requestAuthorization() }
                        }
                    })
                    .buttonStyle(BouncyButtonStyle())

                    Button("onb_skip") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            hasOnboarded = true
                        }
                    }
                    .buttonStyle(GlassButtonStyle())
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: showContent)
        .onAppear {
            animateIcon = true
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                showContent = true
            }
        }
        .onChange(of: wantsNotifications) { _, newValue in
            Task {
                if newValue {
                    _ = await scheduler.requestAuthorization()
                } else {
                    await scheduler.scheduleConfiguredDayparts(
                        morning: false, midday: false, afternoon: false, evening: false,
                        quietStartHour: 22, quietEndHour: 7
                    )
                }
            }
        }
    }
}

#Preview { OnboardingPermissionsView() }
