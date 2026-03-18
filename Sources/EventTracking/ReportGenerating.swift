import Foundation

protocol ReportGenerating {
    func generateReport() -> String
}

protocol CacheTrackable {
    func trackCacheHit(eventName: String, displayName: String)
}
