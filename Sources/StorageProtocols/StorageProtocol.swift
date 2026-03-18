import Foundation

protocol StorageProviding {
    func save(key: String, value: Any)
    func load(key: String) -> Any?
    func delete(key: String)
    func clear()
}

protocol CacheProviding {
    func formattedSummary() -> String
    func isValidKey(_ key: String) -> Bool
}

protocol SessionProviding {
    func saveUserSession(userId: String, token: String, expiresIn: TimeInterval)
    func isSessionValid(userId: String) -> Bool
}
