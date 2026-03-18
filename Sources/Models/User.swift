import Foundation

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

    public var displayName: String {
        isActive ? name : "\(name) (inactive)"
    }

    public var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
}
