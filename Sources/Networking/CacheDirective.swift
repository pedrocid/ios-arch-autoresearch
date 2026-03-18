import Foundation

public enum CacheDirective: Sendable {
    case never
    case always
    case duration(TimeInterval)
    case untilAppRestart

    public var httpHeaderValue: String {
        switch self {
        case .never: return "no-cache, no-store"
        case .always: return "max-age=31536000"
        case .duration(let seconds): return "max-age=\(Int(seconds))"
        case .untilAppRestart: return "private, max-age=3600"
        }
    }
}
