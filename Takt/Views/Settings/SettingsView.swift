import SwiftUI

struct SettingsView: View {
    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.openURL) private var openURL
    @Environment(\.notificationScheduler) private var scheduler
    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled: Bool = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    // Nudges configuration
    @AppStorage("nudgeMorning") private var nudgeMorning: Bool = true
    @AppStorage("nudgeMidday") private var nudgeMidday: Bool = true
    @AppStorage("nudgeAfternoon") private var nudgeAfternoon: Bool = true
    @AppStorage("nudgeEvening") private var nudgeEvening: Bool = true
    @AppStorage("quietStartHour") private var quietStartHour: Int = 22
    @AppStorage("quietEndHour") private var quietEndHour: Int = 7

    private var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        return [version, build].filter { !$0.isEmpty }.joined(separator: " (") + (build.isEmpty ? "" : ")")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Subscription Section
                VStack(alignment: .leading, spacing: 16) {
                    Label {
                        Text("settings_subscription")
                            .font(.headline)
                            .foregroundStyle(Color("PrimaryColor"))
                    } icon: {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(LinearGradient.primary)
                    }

                    Card(style: .glass) {
                        VStack(spacing: 10) {
                            SettingRow(
                                icon: "creditcard.fill",
                                title: "settings_manage_subscription",
                                trailing: AnyView(Image(systemName: "chevron.right").font(.caption).foregroundStyle(Color("OnSurfaceSecondary")))
                            ) {
                                Task { await subscriptions.manageSubscriptions() }
                            }

                            Divider()

                            SettingRow(
                                icon: "arrow.clockwise",
                                title: "settings_restore_purchases",
                                trailing: AnyView(EmptyView())
                            ) {
                                Task { try? await subscriptions.restorePurchases() }
                            }
                            .padding(.leading, 3)
                        }
                    }
                }

                // Preferences Section
                VStack(alignment: .leading, spacing: 16) {
                    Label {
                        Text("settings_preferences")
                            .font(.headline)
                            .foregroundStyle(Color("PrimaryColor"))
                    } icon: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(LinearGradient.primary)
                    }

                    Card(style: .glass) {
                        VStack(spacing: 12) {
                            SettingToggle(
                                title: "settings_icloud_sync",
                                icon: "icloud.fill",
                                isOn: $iCloudSyncEnabled,
                                color: Color("PrimaryColor")
                            )

                            Divider()

                            SettingToggle(
                                title: "settings_notifications",
                                icon: "bell.fill",
                                isOn: $notificationsEnabled,
                                color: Color("SecondaryColor")
                            )
                            .onChange(of: notificationsEnabled) { _, newValue in
                                Task {
                                    if newValue {
                                        _ = await scheduler.requestAuthorization()
                                        await scheduler.scheduleConfiguredDayparts(
                                            morning: nudgeMorning,
                                            midday: nudgeMidday,
                                            afternoon: nudgeAfternoon,
                                            evening: nudgeEvening,
                                            quietStartHour: quietStartHour,
                                            quietEndHour: quietEndHour
                                        )
                                    } else {
                                        await scheduler.scheduleConfiguredDayparts(
                                            morning: false, midday: false, afternoon: false, evening: false,
                                            quietStartHour: quietStartHour, quietEndHour: quietEndHour
                                        )
                                    }
                                }
                            }
                            if notificationsEnabled {
                                VStack(spacing: 12) {
                                    Divider()

                                    Text("Notification Schedule")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    NudgeToggle(title: "settings_nudge_morning", icon: "sunrise.fill", isOn: $nudgeMorning, color: Color("Warning"))
                                        .onChange(of: nudgeMorning) { _, _ in rescheduleNudges() }

                                    NudgeToggle(title: "settings_nudge_midday", icon: "sun.max.fill", isOn: $nudgeMidday, color: Color("PrimaryColor"))
                                        .onChange(of: nudgeMidday) { _, _ in rescheduleNudges() }

                                    NudgeToggle(title: "settings_nudge_afternoon", icon: "sun.haze.fill", isOn: $nudgeAfternoon, color: Color("SecondaryColor"))
                                        .onChange(of: nudgeAfternoon) { _, _ in rescheduleNudges() }

                                    NudgeToggle(title: "settings_nudge_evening", icon: "moon.fill", isOn: $nudgeEvening, color: Color("PrimaryColor"))
                                        .onChange(of: nudgeEvening) { _, _ in rescheduleNudges() }
                                    Divider()

                                    // Quiet hours redesigned (more usable): two aligned bordered chips with +/-
                                    VStack(spacing: 8) {
                                        HStack {
                                            Label("settings_quiet_hours", systemImage: "moon.zzz.fill")
                                                .font(.subheadline)
                                            Spacer()
                                        }

                                        HStack(spacing: 12) {
                                            TimeChip(title: "Start", value: $quietStartHour)
                                            Text("—").foregroundStyle(Color("OnSurfaceSecondary"))
                                            TimeChip(title: "End", value: $quietEndHour)
                                        }
                                    }

                                    Button {
                                        Task { await scheduler.scheduleNudgeNow() }
                                    } label: {
                                        Label("settings_send_test_nudge", systemImage: "bell.badge")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(SecondaryButtonStyle())
                                }
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                    }
                }

                // Support & Legal Section
                VStack(alignment: .leading, spacing: 16) {
                    Label {
                        Text("settings_support_legal")
                            .font(.headline)
                            .foregroundStyle(Color("PrimaryColor"))
                    } icon: {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundStyle(LinearGradient.primary)
                    }

                    Card(style: .elevated) {
                        VStack(spacing: 12) {
                            Button {
                                if let url = URL(string: "mailto:support@takt.app") { openURL(url) }
                            } label: {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        .foregroundStyle(Color("Success"))
                                    Text("settings_contact_support")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .foregroundStyle(.primary)
                            }

                            Divider()

                            Link(destination: URL(string: "https://takt.app/privacy")!) {
                                HStack {
                                    Image(systemName: "hand.raised.fill")
                                        .foregroundStyle(Color("PrimaryColor"))
                                    Text("settings_privacy_policy")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .foregroundStyle(.primary)
                            }

                            Divider()

                            Link(destination: URL(string: "https://takt.app/terms")!) {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .foregroundStyle(Color("SecondaryColor"))
                                    Text("settings_terms")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                    }
                }

                // About Section
                VStack(alignment: .leading, spacing: 16) {
                    Label {
                        Text("settings_about")
                            .font(.headline)
                            .foregroundStyle(Color("PrimaryColor"))
                    } icon: {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(LinearGradient.primary)
                    }

                    Card(style: .flat) {
                        HStack {
                            Label("settings_version", systemImage: "app.badge.fill")
                            Spacer()
                            Text(appVersion)
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)
                        }
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle(Text("settings_title"))
        .navigationBarTitleDisplayMode(.large)
        .background(AppBackground())
    }

    private func rescheduleNudges() {
        Task {
            await scheduler.scheduleConfiguredDayparts(
                morning: nudgeMorning,
                midday: nudgeMidday,
                afternoon: nudgeAfternoon,
                evening: nudgeEvening,
                quietStartHour: quietStartHour,
                quietEndHour: quietEndHour
            )
        }
    }
}

// Setting Toggle Component
struct SettingToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        HStack {
            Label {
                Text(LocalizedStringKey(title))
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(color)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
        }
    }
}

// Nudge Toggle Component
struct NudgeToggle: View {
    let title: String
    let icon: String
    @Binding var isOn: Bool
    let color: Color

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.footnote)
                    .foregroundStyle(color)
            }

            Text(LocalizedStringKey(title))
                .font(.subheadline)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
                .scaleEffect(0.8)
        }
    }
}

// Generic Settings Row (icon + title + trailing content) with consistent padding/colors
private struct SettingRow: View {
    let icon: String
    let title: String
    let trailing: AnyView
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(LinearGradient.primary)

                Text(LocalizedStringKey(title))
                    .font(.body)
                    .foregroundStyle(Color("OnSurfacePrimary"))

                Spacer()

                trailing
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Quiet hours chips with thin borders and +/- controls
private struct TimeChip: View {
    let title: String
    @Binding var value: Int

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Color("OnSurfaceSecondary"))
            Button { decrement() } label: {
                Image(systemName: "minus")
                    .font(.caption2)
            }
            .buttonStyle(SecondaryButtonStyle(isCompact: true))

            Text(String(format: "%02d:00", value))
                .font(.subheadline).monospacedDigit()
                .foregroundStyle(Color("OnSurfacePrimary"))

            Button { increment() } label: {
                Image(systemName: "plus")
                    .font(.caption2)
            }
            .buttonStyle(SecondaryButtonStyle(isCompact: true))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.thinMaterial)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("Border"), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func decrement() { value = max(0, value - 1) }
    private func increment() { value = min(23, value + 1) }
}

#Preview { NavigationStack { SettingsView() } }
