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
        Form {
            Section(header: Text("settings_subscription")) {
                Button("settings_manage_subscription") { Task { await subscriptions.manageSubscriptions() } }
                Button("settings_restore_purchases") { Task { try? await subscriptions.restorePurchases() } }
            }

            Section(header: Text("settings_preferences")) {
                Toggle("settings_icloud_sync", isOn: $iCloudSyncEnabled)
                Toggle("settings_notifications", isOn: $notificationsEnabled)
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
                    Toggle("settings_nudge_morning", isOn: $nudgeMorning)
                        .onChange(of: nudgeMorning) { _, _ in rescheduleNudges() }
                    Toggle("settings_nudge_midday", isOn: $nudgeMidday)
                        .onChange(of: nudgeMidday) { _, _ in rescheduleNudges() }
                    Toggle("settings_nudge_afternoon", isOn: $nudgeAfternoon)
                        .onChange(of: nudgeAfternoon) { _, _ in rescheduleNudges() }
                    Toggle("settings_nudge_evening", isOn: $nudgeEvening)
                        .onChange(of: nudgeEvening) { _, _ in rescheduleNudges() }
                    HStack {
                        Text("settings_quiet_hours")
                        Spacer()
                        Stepper(value: $quietStartHour, in: 0 ... 23) { Text(String(format: "%02d:00", quietStartHour)) }
                        Text("—")
                        Stepper(value: $quietEndHour, in: 0 ... 23) { Text(String(format: "%02d:00", quietEndHour)) }
                    }
                    Button("settings_send_test_nudge") { Task { await scheduler.scheduleNudgeNow() } }
                        .buttonStyle(HapticButtonStyle())
                }
            }

            Section(header: Text("settings_support_legal")) {
                Button("settings_contact_support") {
                    if let url = URL(string: "mailto:support@takt.app") { openURL(url) }
                }
                Link("settings_privacy_policy", destination: URL(string: "https://takt.app/privacy")!)
                Link("settings_terms", destination: URL(string: "https://takt.app/terms")!)
            }

            Section(header: Text("settings_about")) {
                HStack { Text("settings_version"); Spacer(); Text(appVersion).foregroundStyle(.secondary) }
            }
        }
        .navigationTitle(Text("settings_title"))
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

#Preview { NavigationStack { SettingsView() } }
