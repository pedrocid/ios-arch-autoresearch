import Foundation
public struct Product: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let price: Double
    public let category: String
    public let imageURL: String?
    public init(id: String, name: String, price: Double, category: String, imageURL: String? = nil) { self.id = id; self.name = name; self.price = price; self.category = category; self.imageURL = imageURL }
    public var formattedPrice: String { String(format: "$%.2f", price) }
    public var isOnSale: Bool { category == "clearance" || price < 10.0 }
}
