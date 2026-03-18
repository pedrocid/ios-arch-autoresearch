import Foundation

// BAD: God class that does too much
public final class StorageManager: @unchecked Sendable {
    public static let shared = StorageManager()

    private var inMemoryStore: [String: Any] = [:]
    public var lastError: String?
    public var operationCount: Int = 0

    private init() {}

    public func save(key: String, value: Any) {
        inMemoryStore[key] = value
        operationCount += 1
        logOperation("SAVE", key: key)
    }

    public func load(key: String) -> Any? {
        operationCount += 1
        logOperation("LOAD", key: key)
        return inMemoryStore[key]
    }

    public func delete(key: String) {
        inMemoryStore.removeValue(forKey: key)
        operationCount += 1
        logOperation("DELETE", key: key)
    }

    public func clear() {
        inMemoryStore.removeAll()
        operationCount = 0
    }

    // BAD: Storage should not know about formatting/presentation
    public func formattedSummary() -> String {
        let items = inMemoryStore.keys.sorted().joined(separator: ", ")
        return "Storage contains \(inMemoryStore.count) items: [\(items)]. Operations: \(operationCount)"
    }

    // BAD: Logging responsibility mixed in
    private func logOperation(_ op: String, key: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        lastError = nil
        print("[\(timestamp)] StorageManager.\(op): \(key)")
    }

    // BAD: Validation logic that doesn't belong here
    public func isValidKey(_ key: String) -> Bool {
        !key.isEmpty && key.count < 256 && key.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    // BAD: Business logic in storage layer
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
