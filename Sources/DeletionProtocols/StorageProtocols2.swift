import Foundation

protocol Deletable {
    func delete(key: String)
}

protocol Saveable {
    func save(key: String, value: Any)
}

protocol Loadable {
    func load(key: String) -> Any?
}
