import Foundation

protocol KeyValueStore {
    func save(key: String, value: Any)
    func load(key: String) -> Any?
    func delete(key: String)
}

protocol Clearable {
    func clear()
}

protocol KeyValidating {
    func isValidKey(_ key: String) -> Bool
}
