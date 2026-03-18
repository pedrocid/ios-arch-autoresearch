import Foundation

extension StorageManager {
    public func isValidKey(_ key: String) -> Bool {
        !key.isEmpty && key.count < 256 && key.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    public func saveUserSession(userId: String, token: String, expiresIn: TimeInterval) {
        let expiry = Date().addingTimeInterval(expiresIn)
        save(key: "session_\(userId)_token", value: token)
        save(key: "session_\(userId)_expiry", value: expiry)
    }

    public func isSessionValid(userId: String) -> Bool {
        guard let expiry = load(key: "session_\(userId)_expiry") as? Date else { return false }
        return expiry > Date()
    }
}
