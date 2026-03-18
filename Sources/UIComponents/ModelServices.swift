import Foundation
import Models
import Networking
import Storage

extension User {
    public static func fetch(id: String) async throws -> User {
        let data = try await APIClient.default.fetchUser(id: id)
        return try JSONDecoder().decode(User.self, from: data)
    }

    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.default.save(key: "user_\(id)", value: data as Any)
    }
}

extension Product {
    public static func fetchAll(category: String) async throws -> [Product] {
        let data = try await APIClient.default.fetchProducts(category: category)
        return try JSONDecoder().decode([Product].self, from: data)
    }

    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.default.save(key: "product_\(id)", value: data as Any)
    }
}

extension Order {
    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.default.save(key: "order_\(id)", value: data as Any)
    }
}
