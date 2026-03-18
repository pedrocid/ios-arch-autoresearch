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
}

enum RemoteImageLoader {
    static func loadImage(from urlString: String) async throws -> Data {
        try await Networking.ImageLoader.default.loadImage(from: urlString)
    }
}
