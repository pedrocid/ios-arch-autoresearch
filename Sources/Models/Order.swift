import Foundation
public struct Order: Codable, Equatable, Sendable {
    public let id: String; public let userId: String; public var products: [Product]; public let createdAt: Date; public var status: OrderStatus
    public enum OrderStatus: String, Codable, Sendable { case pending, confirmed, shipped, delivered, cancelled }
    public init(id: String, userId: String, products: [Product], createdAt: Date = Date(), status: OrderStatus = .pending) { self.id = id; self.userId = userId; self.products = products; self.createdAt = createdAt; self.status = status }
    public var total: Double { products.reduce(0) { $0 + $1.price } }
    public var totalWithTax: Double { total * 1.21 }
    public var formattedTotal: String { String(format: "$%.2f (inc. tax: $%.2f)", total, totalWithTax) }
    public func canCancel() -> Bool { status == .pending || status == .confirmed }
    public var formattedDate: String { let f = DateFormatter(); f.dateStyle = .medium; return f.string(from: createdAt) }
}
