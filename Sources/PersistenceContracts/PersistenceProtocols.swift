import Foundation

protocol SessionManaging {
    func saveUserSession(userId: String, token: String, expiresIn: TimeInterval)
    func isSessionValid(userId: String) -> Bool
}

protocol LoggingOperation {
    var lastError: String? { get }
}
