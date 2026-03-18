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

    public static func load(userId: String) async throws -> UserProfileViewModel {
        let user = try await User.fetch(id: userId)

        var avatarData: Data?
        if let url = user.avatarURL {
            avatarData = try? await RemoteImageLoader.loadImage(from: url)
        }

        return UserProfileViewModel(
            userId: user.id,
            displayName: user.displayName,
            email: user.email,
            avatarData: avatarData,
            isActive: user.isActive
        )
    }
}
