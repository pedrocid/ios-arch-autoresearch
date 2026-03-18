import Foundation
open class APIClient: @unchecked Sendable {
    public static let `default` = APIClient()
    public var baseURL: String = "https://api.example.com"
    public var timeoutInterval: TimeInterval = 30
    public var lastError: String?
    public init() {}
    public func fetch(endpoint: String, cacheDirective: CacheDirective = .never) async throws -> Data {
        let url = URL(string: "\(baseURL)/\(endpoint)")!
        var request = URLRequest(url: url); request.timeoutInterval = timeoutInterval; request.setValue(cacheDirective.httpHeaderValue, forHTTPHeaderField: "Cache-Control")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200...299).contains(httpResponse.statusCode) else { lastError = "HTTP \(httpResponse.statusCode) for \(endpoint)"; throw APIError.httpError(statusCode: httpResponse.statusCode) }
        return data
    }
    public func fetchUser(id: String) async throws -> Data { try await fetch(endpoint: "users/\(id)", cacheDirective: .duration(300)) }
    public func fetchProducts(category: String) async throws -> Data { try await fetch(endpoint: "products?category=\(category)", cacheDirective: .always) }
    public func statusDescription() -> String { lastError.map { "API Status: Error - \($0)" } ?? "API Status: OK (base: \(baseURL))" }
}
