import Foundation

protocol Persistable {
    func save()
}

protocol Fetchable {
    associatedtype ID
    static func fetch(id: ID) async throws -> Self
}
