import Foundation

public final class StorageManager: @unchecked Sendable {
    public static let `default` = StorageManager()

    private var inMemoryStore: [String: Any] = [:]
    public var lastError: String?
    public var operationCount: Int = 0

    public init() {}

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

    public func formattedSummary() -> String {
        let items = inMemoryStore.keys.sorted().joined(separator: ", ")
        return "Storage contains \(inMemoryStore.count) items: [\(items)]. Operations: \(operationCount)"
    }

    private func logOperation(_ op: String, key: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        lastError = nil
        print("[\(timestamp)] StorageManager.\(op): \(key)")
    }
}
