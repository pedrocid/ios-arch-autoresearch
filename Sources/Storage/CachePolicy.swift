import Foundation

// BAD: Enum with too many responsibilities
public enum CachePolicy {
    case never
    case always
    case duration(TimeInterval)
    case untilAppRestart

    // BAD: Contains HTTP-specific logic in storage layer
    public var httpHeaderValue: String {
        switch self {
        case .never: return "no-cache, no-store"
        case .always: return "max-age=31536000"
        case .duration(let seconds): return "max-age=\(Int(seconds))"
        case .untilAppRestart: return "private, max-age=3600"
        }
    }

    // BAD: UI-specific logic in storage layer
    public var displayName: String {
        switch self {
        case .never: return "No caching"
        case .always: return "Cache forever"
        case .duration(let seconds): return "Cache for \(Int(seconds))s"
        case .untilAppRestart: return "Until restart"
        }
    }

    // BAD: Analytics-specific logic in storage layer
    public var analyticsEventName: String {
        switch self {
        case .never: return "cache_policy_none"
        case .always: return "cache_policy_permanent"
        case .duration: return "cache_policy_timed"
        case .untilAppRestart: return "cache_policy_session"
        }
    }
}
