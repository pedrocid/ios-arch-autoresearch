import Foundation
import Models

public final class AnalyticsTracker: @unchecked Sendable {
    public static let `default` = AnalyticsTracker()

    private var events: [(name: String, timestamp: Date, metadata: [String: String])] = []

    public init() {}

    public func track(event: String, metadata: [String: String] = [:]) {
        events.append((name: event, timestamp: Date(), metadata: metadata))
    }

    public func trackUserLogin(user: User) {
        track(event: "user_login", metadata: [
            "user_id": user.id,
            "is_active": "\(user.isActive)",
            "display_name": user.displayName
        ])
    }

    public func trackProductView(product: Product) {
        track(event: "product_view", metadata: [
            "product_id": product.id,
            "category": product.category,
            "price": product.formattedPrice,
            "is_on_sale": "\(product.isOnSale)"
        ])
    }

    public func trackOrderPlaced(order: Order) {
        track(event: "order_placed", metadata: [
            "order_id": order.id,
            "total": "\(order.total)",
            "product_count": "\(order.products.count)",
            "status": order.status.rawValue
        ])
    }

    public func generateReport() -> String {
        let grouped = Dictionary(grouping: events, by: { $0.name })
        var report = "=== Analytics Report ===\n"
        for (event, occurrences) in grouped.sorted(by: { $0.key < $1.key }) {
            report += "\(event): \(occurrences.count) times\n"
        }
        report += "Total events: \(events.count)\n"
        return report
    }

    public func trackCacheHit(eventName: String, displayName: String) {
        track(event: eventName, metadata: ["display": displayName])
    }
}
