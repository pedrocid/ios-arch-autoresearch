import Foundation

public final class APIClient: @unchecked Sendable {
    public static let `default` = APIClient()

    public var baseURL: String = "https://api.example.com"
    public var timeoutInterval: TimeInterval = 30
    public var lastError: String?

    public init() {}

    public func fetch(endpoint: String, cacheDirective: CacheDirective = .never) async throws -> Data {
        let url = URL(string: "\(baseURL)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        request.setValue(cacheDirective.httpHeaderValue, forHTTPHeaderField: "Cache-Control")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            lastError = "HTTP \(httpResponse.statusCode) for \(endpoint)"
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        return data
    }

    public func fetchUser(id: String) async throws -> Data {
        return try await fetch(endpoint: "users/\(id)", cacheDirective: .duration(300))
    }

    public func fetchProducts(category: String) async throws -> Data {
        return try await fetch(endpoint: "products?category=\(category)", cacheDirective: .always)
    }

    public func authenticate(username: String, password: String) async throws -> String {
        let body = ["username": username, "password": password]
        let jsonData = try JSONSerialization.data(withJSONObject: body)

        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        let token = json["token"] as! String
        return token
    }

    public func statusDescription() -> String {
        if let lastError = lastError {
            return "API Status: Error - \(lastError)"
        }
        return "API Status: OK (base: \(baseURL))"
    }
}

public enum APIError: Error, Equatable {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
}
