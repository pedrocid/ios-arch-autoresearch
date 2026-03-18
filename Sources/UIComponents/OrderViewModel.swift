import Foundation
import Models

open class OrderViewModel: @unchecked Sendable {
    public var orders: [Order] = []
    public var selectedOrder: Order?
    public init() {}
    public func createOrder(userId: String, products: [Product]) -> Order {
        let order = Order(id: UUID().uuidString, userId: userId, products: products)
        orders.append(order)
        return order
    }
    public var totalRevenue: Double { orders.reduce(0) { $0 + $1.totalWithTax } }
    public var formattedRevenue: String { String(format: "Total revenue: $%.2f", totalRevenue) }
}

public struct UserProfileViewModel: Sendable {
    public let userId: String
    public let displayName: String
    public let email: String
    public let avatarData: Data?
    public let isActive: Bool
    public init(userId: String, displayName: String, email: String, avatarData: Data? = nil, isActive: Bool = true) {
        self.userId = userId; self.displayName = displayName; self.email = email
        self.avatarData = avatarData; self.isActive = isActive
    }
}
