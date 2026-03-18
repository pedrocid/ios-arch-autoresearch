import Foundation
import Models

public final class OrderViewModel: @unchecked Sendable {
    public var orders: [Order] = []
    public var selectedOrder: Order?

    public init() {}

    public func createOrder(userId: String, products: [Product]) -> Order {
        let order = Order(
            id: UUID().uuidString,
            userId: userId,
            products: products
        )
        orders.append(order)
        return order
    }

    public var totalRevenue: Double {
        orders.reduce(0) { $0 + $1.totalWithTax }
    }

    public var formattedRevenue: String {
        String(format: "Total revenue: $%.2f", totalRevenue)
    }
}
