import Foundation

protocol CacheDirectiveProviding {
    var httpHeaderValue: String { get }
}

protocol DataFetching {
    associatedtype Directive
    func fetch(endpoint: String, cacheDirective: Directive) async throws -> Data
}

protocol PlaceholderProviding {
    func placeholderImageData() -> Data
}
