import Foundation

protocol UserFetching {
    func fetchUser(id: String) async throws -> Data
}

protocol ProductFetching {
    func fetchProducts(category: String) async throws -> Data
}

protocol ImageCaching {
    func loadImage(from urlString: String) async throws -> Data
}

protocol ErrorReporting {
    var lastError: String? { get }
}
