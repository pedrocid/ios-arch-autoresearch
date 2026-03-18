import Foundation

protocol AnalyticsProviding {
    func track(event: String, metadata: [String: String])
    func generateReport() -> String
}

protocol EventTracking {
    func trackCacheHit(eventName: String, displayName: String)
}
