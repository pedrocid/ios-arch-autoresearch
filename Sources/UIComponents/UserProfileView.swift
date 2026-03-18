import Foundation
import Models

public struct UserProfileViewModel: Sendable {
    public let userId: String
    public let displayName: String
    public let email: String
    public let avatarData: Data?
    public let isActive: Bool

    public init(userId: String, displayName: String, email: String, avatarData: Data? = nil, isActive: Bool = true) {
        self.userId = userId
        self.displayName = displayName
        self.email = email
        self.avatarData = avatarData
        self.isActive = isActive
    }
}
