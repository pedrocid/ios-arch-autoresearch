import Foundation

protocol APIProviding {
    associatedtype Directive
    func fetch(endpoint: String, cacheDirective: Directive) async throws -> Data
    func fetchUser(id: String) async throws -> Data
    func fetchProducts(category: String) async throws -> Data
    func statusDescription() -> String
}

protocol ImageProviding {
    func loadImage(from urlString: String) async throws -> Data
    func placeholderImageData() -> Data
}
