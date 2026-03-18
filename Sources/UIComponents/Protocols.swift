import Foundation
import Models

protocol ProductListProviding {
    var products: [Product] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    func loadProducts(category: String) async
}

protocol OrderProviding {
    var orders: [Order] { get }
    func createOrder(userId: String, products: [Product]) -> Order
}

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

protocol ErrorDisplayable {
    var errorMessage: String? { get }
}

protocol Selectable {
    associatedtype Item
    var selectedOrder: Item? { get }
}

protocol SaleFiltering {
    associatedtype Product
    var saleProducts: [Product] { get }
}
