import Foundation

protocol URLProviding {
    var baseURL: String { get }
}

protocol ThumbnailProviding {
    func thumbnailURL(for originalURL: String, size: Int) -> String
}
