import Foundation

protocol RequestProviding {
    var baseURL: String { get }
    var timeoutInterval: TimeInterval { get }
}

protocol Authenticating {
    func authenticate(username: String, password: String) async throws -> String
}
