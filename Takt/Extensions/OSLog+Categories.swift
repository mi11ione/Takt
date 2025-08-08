import Foundation
import OSLog

// Centralized OSLog/Logger categories
public let bundleID: String = Bundle.main.bundleIdentifier ?? "com.mi11ion.Takt"

public extension Logger {
    static let app = Logger(subsystem: bundleID, category: "app")
    static let networking = Logger(subsystem: bundleID, category: "networking")
    static let subscription = Logger(subsystem: bundleID, category: "subscription")
    static let analytics = Logger(subsystem: bundleID, category: "analytics")
    static let performance = Logger(subsystem: bundleID, category: "performance")
    static let widget = Logger(subsystem: bundleID, category: "widget")
    static let liveActivity = Logger(subsystem: bundleID, category: "live-activity")
}
