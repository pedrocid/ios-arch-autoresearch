import Foundation
import Models
import Networking
import Storage

// BAD: Analytics coupled to everything
public final class AnalyticsTracker: @unchecked Sendable {
    public static let shared = AnalyticsTracker()

    private let storage = StorageManager.shared
    private var events: [(name: String, timestamp: Date, metadata: [String: String])] = []

    private init() {}

    public func track(event: String, metadata: [String: String] = [:]) {
        events.append((name: event, timestamp: Date(), metadata: metadata))
        // BAD: Analytics persists via storage directly
        storage.save(key: "analytics_last_event", value: event)
        storage.save(key: "analytics_count", value: events.count)
    }

    // BAD: Analytics knows about domain models
    public func trackUserLogin(user: User) {
        track(event: "user_login", metadata: [
            "user_id": user.id,
            "is_active": "\(user.isActive)",
            "display_name": user.displayName
        ])
    }

    // BAD: Analytics knows about products
    public func trackProductView(product: Product) {
        track(event: "product_view", metadata: [
            "product_id": product.id,
            "category": product.category,
            "price": product.formattedPrice,
            "is_on_sale": "\(product.isOnSale)"
        ])
    }

    // BAD: Analytics knows about orders
    public func trackOrderPlaced(order: Order) {
        track(event: "order_placed", metadata: [
            "order_id": order.id,
            "total": "\(order.total)",
            "product_count": "\(order.products.count)",
            "status": order.status.rawValue
        ])
    }

    // BAD: Analytics contains reporting logic
    public func generateReport() -> String {
        let grouped = Dictionary(grouping: events, by: { $0.name })
        var report = "=== Analytics Report ===\n"
        for (event, occurrences) in grouped.sorted(by: { $0.key < $1.key }) {
            report += "\(event): \(occurrences.count) times\n"
        }
        report += "Total events: \(events.count)\n"
        // BAD: Accesses storage directly for report
        report += "Storage summary: \(storage.formattedSummary())\n"
        // BAD: Accesses networking status in analytics
        report += "API status: \(APIClient.shared.statusDescription())\n"
        return report
    }

    // BAD: Cache management in analytics
    public func trackCacheHit(policy: CachePolicy) {
        track(event: policy.analyticsEventName, metadata: ["display": policy.displayName])
    }
}
