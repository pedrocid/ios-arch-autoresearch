import Foundation

public enum APIError: Error, Equatable {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(String)
}
