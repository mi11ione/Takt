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
        }
    }
}

private extension TaktApp {
    static func makeModelContainer() -> ModelContainer {
        let schema = DataModelSchema.current
        if let container = try? ModelContainer(for: schema) {
            return container
        }
        // Fallback to an in‑memory store to keep the app usable in development.
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        if let inMemory = try? ModelContainer(for: schema, configurations: configuration) {
            return inMemory
        }
        preconditionFailure("Failed to initialize SwiftData ModelContainer")
    }
}
