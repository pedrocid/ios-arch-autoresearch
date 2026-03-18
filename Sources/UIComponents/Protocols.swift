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

protocol SaleFiltering {
    associatedtype Product
    var saleProducts: [Product] { get }
}
