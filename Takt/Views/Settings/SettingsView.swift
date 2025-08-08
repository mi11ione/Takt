import SwiftUI

struct SettingsView: View {
    @Environment(\.subscriptionManager) private var subscriptions
    @Environment(\.openURL) private var openURL
    @Environment(\.notificationScheduler) private var scheduler
    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled: Bool = true
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true

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
                                await scheduler.scheduleDaypartSuggestions(enabled: true)
                            } else {
                                await scheduler.scheduleDaypartSuggestions(enabled: false)
                            }
                        }
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
}

#Preview { NavigationStack { SettingsView() } }
