import Foundation

protocol CacheDirectiveProviding {
    var httpHeaderValue: String { get }
}

protocol DataFetching {
    func fetch(endpoint: String, cacheDirective: CacheDirective) async throws -> Data
}

protocol PlaceholderProviding {
    func placeholderImageData() -> Data
}
