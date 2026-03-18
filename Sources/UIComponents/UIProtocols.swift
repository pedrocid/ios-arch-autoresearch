import Foundation

protocol HeaderProviding {
    var headerText: String { get }
}

protocol LoadingState {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}

protocol RevenueTracking {
    var totalRevenue: Double { get }
    var formattedRevenue: String { get }
}

protocol ProfileLoading {
    static func load(userId: String) async throws -> Self
}
