import Foundation

public enum CachePolicy {
    case never, always, duration(TimeInterval), untilAppRestart
    public var httpHeaderValue: String { switch self { case .never: return "no-cache, no-store"; case .always: return "max-age=31536000"; case .duration(let s): return "max-age=\(Int(s))"; case .untilAppRestart: return "private, max-age=3600" } }
    public var displayName: String { switch self { case .never: return "No caching"; case .always: return "Cache forever"; case .duration(let s): return "Cache for \(Int(s))s"; case .untilAppRestart: return "Until restart" } }
    public var analyticsEventName: String { switch self { case .never: return "cache_policy_none"; case .always: return "cache_policy_permanent"; case .duration: return "cache_policy_timed"; case .untilAppRestart: return "cache_policy_session" } }
}
