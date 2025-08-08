import Foundation
import StoreKit

/// StoreKit 2 subscription management abstraction.
/// Pricing policy (annual‑first): $4.99/mo or $24.99/yr; no trial. Product IDs to be added later.
public protocol SubscriptionManaging: Sendable {
    func isSubscribed() async -> Bool
    func purchasePremium() async throws
    func restorePurchases() async throws
    func manageSubscriptions() async
}

public enum SubscriptionError: Error {
    case notImplemented
}

public struct StoreKitSubscriptionManager: SubscriptionManaging, Sendable {
    public init() {}

    public func isSubscribed() async -> Bool {
        // Check current entitlements for an active auto‑renewable subscription
        for await result in Transaction.currentEntitlements {
            if case let .verified(transaction) = result, transaction.productType == .autoRenewable {
                return true
            }
        }
        return false
    }

    public func purchasePremium() async throws {
        // To be implemented once product identifiers are defined.
        throw SubscriptionError.notImplemented
    }

    public func restorePurchases() async throws {
        try await AppStore.sync()
    }

    public func manageSubscriptions() async {}
}
