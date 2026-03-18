import Foundation
import Storage

// BAD: Model with too many responsibilities
public struct Order: Codable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public var products: [Product]
    public let createdAt: Date
    public var status: OrderStatus

    public enum OrderStatus: String, Codable, Sendable {
        case pending, confirmed, shipped, delivered, cancelled
    }

    public init(id: String, userId: String, products: [Product], createdAt: Date = Date(), status: OrderStatus = .pending) {
        self.id = id
        self.userId = userId
        self.products = products
        self.createdAt = createdAt
        self.status = status
    }

    // BAD: Business logic in model
    public var total: Double {
        products.reduce(0) { $0 + $1.price }
    }

    // BAD: Tax calculation in model
    public var totalWithTax: Double {
        total * 1.21 // Spanish IVA hardcoded!
    }

    // BAD: Presentation in model
    public var formattedTotal: String {
        String(format: "$%.2f (inc. tax: $%.2f)", total, totalWithTax)
    }

    // BAD: Persistence in model
    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.shared.save(key: "order_\(id)", value: data as Any)
    }

    // BAD: Status validation logic in model
    public func canCancel() -> Bool {
        status == .pending || status == .confirmed
    }

    // BAD: Date formatting in model
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
}
