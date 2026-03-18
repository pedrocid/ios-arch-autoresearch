import Foundation
import Storage

// BAD: Another networking class tightly coupled to storage
public final class ImageLoader: @unchecked Sendable {
    public static let `default` = ImageLoader()

    private let storage = StorageManager.default
    private let apiClient = APIClient.default

    public init() {}

    public func loadImage(from urlString: String) async throws -> Data {
        let cacheKey = "img_\(urlString.hashValue)"

        // BAD: Duplicate caching logic (same as APIClient)
        if let cached = storage.load(key: cacheKey) as? Data {
            return cached
        }

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)

        storage.save(key: cacheKey, value: data)
        return data
    }

    // BAD: UI concerns in networking layer
    public func placeholderImageData() -> Data {
        // Returns 1x1 transparent PNG bytes
        return Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==")!
    }

    // BAD: Business logic about image sizing
    public func thumbnailURL(for originalURL: String, size: Int) -> String {
        return "\(originalURL)?w=\(size)&h=\(size)&fit=crop"
    }
}
