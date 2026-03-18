import Foundation
import Storage

// BAD: Networking directly depends on Storage (should go through an abstraction)
public final class APIClient: @unchecked Sendable {
    public static let `default` = APIClient()

    private let storage = StorageManager.default
    public var baseURL: String = "https://api.example.com"
    public var timeoutInterval: TimeInterval = 30

    public init() {}

    // BAD: Mixing networking with caching logic
    public func fetch(endpoint: String, cachePolicy: CachePolicy = .never) async throws -> Data {
        let cacheKey = "api_cache_\(endpoint)"

        // BAD: Direct storage access in networking layer
        if case .always = cachePolicy, let cached = storage.load(key: cacheKey) as? Data {
            return cached
        }

        let url = URL(string: "\(baseURL)/\(endpoint)")!
        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval
        request.setValue(cachePolicy.httpHeaderValue, forHTTPHeaderField: "Cache-Control")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            // BAD: Storing error details directly
            storage.save(key: "last_api_error", value: "HTTP \(httpResponse.statusCode) for \(endpoint)")
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        // BAD: Networking layer decides caching strategy
        if case .never = cachePolicy {} else {
            storage.save(key: cacheKey, value: data)
        }

        return data
    }

    // BAD: Knows about user domain concepts
    public func fetchUser(id: String) async throws -> Data {
        return try await fetch(endpoint: "users/\(id)", cachePolicy: .duration(300))
    }

    // BAD: Knows about product domain concepts
    public func fetchProducts(category: String) async throws -> Data {
        return try await fetch(endpoint: "products?category=\(category)", cachePolicy: .always)
    }

    // BAD: Authentication logic in API client
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

        // BAD: Networking layer managing sessions
        storage.saveUserSession(userId: username, token: token, expiresIn: 3600)
        return token
    }

    // BAD: Retry logic mixed with formatting
    public func statusDescription() -> String {
        if let lastError = storage.load(key: "last_api_error") as? String {
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
