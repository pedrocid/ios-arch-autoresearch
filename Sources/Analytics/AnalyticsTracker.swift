import Foundation

open class AnalyticsTracker: @unchecked Sendable {
    public static let `default` = AnalyticsTracker()

    private var events: [(name: String, timestamp: Date, metadata: [String: String])] = []

    public init() {}

    public func track(event: String, metadata: [String: String] = [:]) {
        events.append((name: event, timestamp: Date(), metadata: metadata))
    }

    public func generateReport() -> String {
        let grouped = Dictionary(grouping: events, by: { $0.name })
        var report = "=== Analytics Report ===\n"
        for (event, occurrences) in grouped.sorted(by: { $0.key < $1.key }) {
            report += "\(event): \(occurrences.count) times\n"
        }
        report += "Total events: \(events.count)\n"
        return report
    }

    public func trackCacheHit(eventName: String, displayName: String) {
        track(event: eventName, metadata: ["display": displayName])
    }
}
