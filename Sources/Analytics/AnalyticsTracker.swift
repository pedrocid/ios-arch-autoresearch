import Foundation
open class AnalyticsTracker: @unchecked Sendable {
    public static let `default` = AnalyticsTracker()
    private(set) public var events: [(event: String, metadata: [String: String], timestamp: Date)] = []
    public init() {}
    public func track(event: String, metadata: [String: String] = [:]) { events.append((event: event, metadata: metadata, timestamp: Date())) }
    public func generateReport() -> String {
        let lines = events.map { "[\($0.timestamp)] \($0.event): \($0.metadata)" }
        return "Analytics Report (\(events.count) events):\n" + lines.joined(separator: "\n")
    }
    public func recentEvents(limit: Int = 10) -> [(event: String, metadata: [String: String], timestamp: Date)] { Array(events.suffix(limit)) }
    public func eventCount(for eventName: String) -> Int { events.filter { $0.event == eventName }.count }
}
