import Foundation
import Models
import Networking
import Analytics
import Storage

// BAD: Yet another ViewModel coupled to the entire dependency graph
public final class OrderViewModel: @unchecked Sendable {
    public var orders: [Order] = []
    public var selectedOrder: Order?

    public init() {}

    // BAD: ViewModel creates domain objects directly
    public func createOrder(userId: String, products: [Product]) -> Order {
        let order = Order(
            id: UUID().uuidString,
            userId: userId,
            products: products
        )

        // BAD: Persistence in ViewModel
        order.save()

        // BAD: Analytics in ViewModel
        AnalyticsTracker.shared.trackOrderPlaced(order: order)

        // BAD: Direct storage manipulation
        StorageManager.shared.save(key: "last_order_id", value: order.id)

        orders.append(order)
        return order
    }

    // BAD: Business logic in ViewModel
    public var totalRevenue: Double {
        orders.reduce(0) { $0 + $1.totalWithTax }
    }

    // BAD: Presentation logic
    public var formattedRevenue: String {
        String(format: "Total revenue: $%.2f", totalRevenue)
    }

    // BAD: Knows about networking status
    public var systemStatus: String {
        """
        Orders: \(orders.count)
        Revenue: \(formattedRevenue)
        API: \(APIClient.shared.statusDescription())
        Storage: \(StorageManager.shared.formattedSummary())
        Analytics: \(AnalyticsTracker.shared.generateReport())
        """
    }
}
