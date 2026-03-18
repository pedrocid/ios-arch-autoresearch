import Foundation
import Storage

protocol APIProviding {
    func fetch(endpoint: String, cachePolicy: CachePolicy) async throws -> Data
    func fetchUser(id: String) async throws -> Data
    func fetchProducts(category: String) async throws -> Data
    func statusDescription() -> String
}

protocol ImageProviding {
    func loadImage(from urlString: String) async throws -> Data
    func placeholderImageData() -> Data
}
