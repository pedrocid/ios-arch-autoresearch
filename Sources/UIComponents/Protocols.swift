import Foundation

protocol ProductListProviding {
    associatedtype ProductItem
    var products: [ProductItem] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    func loadProducts(category: String) async
}

protocol OrderProviding {
    associatedtype ProductItem
    associatedtype OrderItem
    var orders: [OrderItem] { get }
    func createOrder(userId: String, products: [ProductItem]) -> OrderItem
}

protocol SaleFiltering {
    associatedtype Product
    var saleProducts: [Product] { get }
}
