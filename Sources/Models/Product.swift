import Foundation
import Networking
import Storage

// BAD: Same pattern - model coupled to infrastructure
public struct Product: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let price: Double
    public let category: String
    public let imageURL: String?

    public init(id: String, name: String, price: Double, category: String, imageURL: String? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.imageURL = imageURL
    }

    // BAD: Model fetches from network
    public static func fetchAll(category: String) async throws -> [Product] {
        let data = try await APIClient.shared.fetchProducts(category: category)
        return try JSONDecoder().decode([Product].self, from: data)
    }

    // BAD: Model manages its own persistence
    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.shared.save(key: "product_\(id)", value: data as Any)
    }

    // BAD: Formatting/presentation in model
    public var formattedPrice: String {
        String(format: "$%.2f", price)
    }

    // BAD: Business logic mixed in
    public var isOnSale: Bool {
        category == "clearance" || price < 10.0
    }

    // BAD: Image loading concern in model
    public func loadImage() async throws -> Data {
        guard let url = imageURL else {
            return ImageLoader.shared.placeholderImageData()
        }
        return try await ImageLoader.shared.loadImage(from: url)
    }
}
