//
//  TaktApp.swift
//  Takt
//
//  Created by mi11ion on 8/8/25.
//

import SwiftData
import SwiftUI

/// Takt — 30–90s Habit Micro‑Doses (Productivity)
/// - App entry point. Wires SwiftData and protocol‑oriented services via Environment.
/// - iOS 18+, SwiftUI‑only. THE VIEW architecture.
/// - Privacy/Analytics: OSLog/MetricKit only; no third‑party SDKs.
/// - Monetization: StoreKit 2; product identifiers to be added in a later PR.

@main
struct TaktApp: App {
    @State private var modelContainer: ModelContainer = Self.makeModelContainer()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .modelContainer(modelContainer)
            .environment(\.networkClient, NetworkClientImpl())
            .environment(\.subscriptionManager, StoreKitSubscriptionManager())
            .environment(\.analytics, DefaultAnalytics.shared)
            .task {
                UNUserNotificationCenter.current().delegate = NotificationHandler.shared
                NotificationHandler.shared.container = modelContainer
                NotificationHandler.shared.registerCategories()
                DeepLinkRouter.shared.modelContainer = modelContainer
                await DeepLinkRouter.shared.consumePendingAction()
            }
        }
    }
}

private extension TaktApp {
    static func makeModelContainer() -> ModelContainer {
        let schema = Schema([
            Habit.self,
            HabitEntry.self,
            Chain.self,
            ChainItem.self,
        ])

        do {
            // Create a persistent store configuration
            let storeURL = URL.applicationSupportDirectory.appending(path: "Takt.sqlite")
            let configuration = ModelConfiguration(url: storeURL, allowsSave: true)
            let container = try ModelContainer(for: schema, configurations: [configuration])

            // Ensure the directory exists
            try FileManager.default.createDirectory(at: URL.applicationSupportDirectory, withIntermediateDirectories: true)

            return container
        } catch {
            // Log the error for debugging
            print("Failed to create ModelContainer: \(error)")

            // Try without custom configuration as fallback
            do {
                return try ModelContainer(for: schema)
            } catch {
                print("Failed to create default ModelContainer: \(error)")
                preconditionFailure("Failed to initialize SwiftData ModelContainer: \(error)")
            }
        }
    }
}
