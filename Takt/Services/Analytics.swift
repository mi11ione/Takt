import Foundation
import MetricKit
import OSLog

public protocol Analytics: Sendable {
    func log(event: String, _ metadata: [String: String]?)
    func signpost(_ name: StaticString)
}

public struct DefaultAnalytics: Analytics, Sendable {
    public static let shared = DefaultAnalytics()
    private let logger = Logger.app
    private let metricObserver = MetricsObserver()

    public init() {
        MXMetricManager.shared.add(metricObserver)
    }

    public func log(event: String, _ metadata: [String: String]? = nil) {
        if let metadata, !metadata.isEmpty {
            logger.log("event=\(event, privacy: .public) meta=\(metadata.description, privacy: .public)")
        } else {
            logger.log("event=\(event, privacy: .public)")
        }
    }

    public func signpost(_ name: StaticString) {
        Logger.performance.log("signpost: \(String(describing: name), privacy: .public)")
    }
}

final class MetricsObserver: NSObject, MXMetricManagerSubscriber {
    func didReceive(_: [MXMetricPayload]) {}
    func didReceive(_: [MXDiagnosticPayload]) {}
}
