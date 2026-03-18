import Foundation
import Models
import Networking

extension User {
    public static func fetch(id: String) async throws -> User {
        let data = try await APIClient.default.fetchUser(id: id)
        return try JSONDecoder().decode(User.self, from: data)
    }
}

extension Product {
    public static func fetchAll(category: String) async throws -> [Product] {
        let data = try await APIClient.default.fetchProducts(category: category)
        return try JSONDecoder().decode([Product].self, from: data)
    }

    public func loadImage() async throws -> Data {
        guard let url = imageURL else {
            return ImageLoader.default.placeholderImageData()
        }
        return try await ImageLoader.default.loadImage(from: url)
    }
}
