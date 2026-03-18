import Foundation
import Models
import Networking
import Analytics
import Storage

// BAD: UI component coupled to networking, analytics, and storage
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

    // BAD: ViewModel fetches data directly from network
    public static func load(userId: String) async throws -> UserProfileViewModel {
        let user = try await User.fetch(id: userId)

        // BAD: ViewModel tracks analytics
        AnalyticsTracker.default.trackUserLogin(user: user)

        // BAD: ViewModel manages caching
        user.save()

        var avatarData: Data?
        if let url = user.avatarURL {
            avatarData = try? await ImageLoader.default.loadImage(from: url)
        }

        return UserProfileViewModel(
            userId: user.id,
            displayName: user.displayName,
            email: user.email,
            avatarData: avatarData,
            isActive: user.isActive
        )
    }

    // BAD: ViewModel knows about storage
    public var storageInfo: String {
        StorageManager.default.formattedSummary()
    }
}
