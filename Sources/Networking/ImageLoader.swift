import Foundation

open class ImageLoader: @unchecked Sendable {
    public static let `default` = ImageLoader()
    private var cache: [String: Data] = [:]
    public init() {}
    public func loadImage(from urlString: String) async throws -> Data {
        let cacheKey = "img_\(urlString.hashValue)"
        if let cached = cache[cacheKey] { return cached }
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        cache[cacheKey] = data
        return data
    }
    public func placeholderImageData() -> Data {
        return Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==")!
    }
    public func thumbnailURL(for originalURL: String, size: Int) -> String {
        return "\(originalURL)?w=\(size)&h=\(size)&fit=crop"
    }
}
