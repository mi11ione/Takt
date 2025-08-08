import Foundation

/// Minimal, stateless network client abstraction. Prefer local processing.
public protocol NetworkClient: Sendable {
    func get(_ url: URL) async throws -> Data
}

public struct NetworkClientImpl: NetworkClient, Sendable {
    public init() {}

    public func get(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
