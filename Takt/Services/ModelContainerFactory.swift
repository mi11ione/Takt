import Foundation
import SwiftData

/// Creates a SwiftData ModelContainer that can be shared between the app and extensions (widgets/intents).
/// IMPORTANT: Set up an App Group (e.g., "group.com.mi11ion.Takt") and update `appGroupIdentifier`.
/// Add the App Group capability to both the app target and the Widget Extension target, and ensure both
/// use this factory to open the same store URL inside the shared container.
enum ModelContainerFactory {
    /// Update this to your App Group identifier. Example: "group.com.mi11ion.Takt".
    static let appGroupIdentifier: String = "group.com.mi11ion.Takt"

    static func makeSharedContainer() throws -> ModelContainer {
        let schema = DataModelSchema.current
        // Try to build a URL in the shared app group container
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            let storeURL = containerURL.appending(path: "Takt.sqlite")
            let configuration = ModelConfiguration(url: storeURL, allowsSave: true)
            return try ModelContainer(for: schema, configurations: [configuration])
        }
        // Fallback: default (non-shared) configuration
        return try ModelContainer(for: schema)
    }
}


