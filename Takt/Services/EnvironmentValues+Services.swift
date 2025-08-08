import SwiftUI

private struct NetworkClientKey: EnvironmentKey {
    static let defaultValue: NetworkClient = NetworkClientImpl()
}

private struct SubscriptionManagerKey: EnvironmentKey {
    static let defaultValue: SubscriptionManaging = StoreKitSubscriptionManager()
}

private struct AnalyticsKey: EnvironmentKey {
    static let defaultValue: Analytics = DefaultAnalytics.shared
}

private struct NotificationSchedulerKey: EnvironmentKey {
    static let defaultValue: NotificationScheduling = NotificationScheduler()
}

public extension EnvironmentValues {
    var networkClient: NetworkClient {
        get { self[NetworkClientKey.self] }
        set { self[NetworkClientKey.self] = newValue }
    }

    var subscriptionManager: SubscriptionManaging {
        get { self[SubscriptionManagerKey.self] }
        set { self[SubscriptionManagerKey.self] = newValue }
    }

    var analytics: Analytics {
        get { self[AnalyticsKey.self] }
        set { self[AnalyticsKey.self] = newValue }
    }

    var notificationScheduler: NotificationScheduling {
        get { self[NotificationSchedulerKey.self] }
        set { self[NotificationSchedulerKey.self] = newValue }
    }
}
