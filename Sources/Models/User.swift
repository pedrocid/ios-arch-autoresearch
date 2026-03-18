import Foundation
import Networking
import Storage

// BAD: Model knows about networking and storage
public struct User: Codable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let avatarURL: String?
    public var isActive: Bool

    public init(id: String, name: String, email: String, avatarURL: String? = nil, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.isActive = isActive
    }

    // BAD: Model fetches itself from network
    public static func fetch(id: String) async throws -> User {
        let data = try await APIClient.default.fetchUser(id: id)
        return try JSONDecoder().decode(User.self, from: data)
    }

    // BAD: Model saves itself to storage
    public func save() {
        let data = try? JSONEncoder().encode(self)
        StorageManager.default.save(key: "user_\(id)", value: data as Any)
    }

    // BAD: Model loads itself from storage
    public static func loadCached(id: String) -> User? {
        guard let data = StorageManager.default.load(key: "user_\(id)") as? Data else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    // BAD: Presentation logic in model
    public var displayName: String {
        isActive ? name : "\(name) (inactive)"
    }

    // BAD: Validation in model with business rules
    public var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
}
