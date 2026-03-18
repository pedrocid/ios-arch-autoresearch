import Foundation
import Models
import UIComponents

protocol QuickOrderProviding { func quickOrder(userId: String, category: String) async -> Order? }
protocol OrderCoordinating { func quickOrder(userId: String, category: String) async -> Order? }

open class AppCoordinator: @unchecked Sendable {
    public let profileVM: UserProfileViewModel?
    public let productVM: ProductListViewModel
    public let orderVM: OrderViewModel
    public init(fetchProducts: @escaping @Sendable (String) async throws -> [Product] = { _ in [] }) {
        self.profileVM = nil; self.productVM = ProductListViewModel(fetchProducts: fetchProducts); self.orderVM = OrderViewModel()
    }
    public func quickOrder(userId: String, category: String) async -> Order? {
        await productVM.loadProducts(category: category)
        guard !productVM.products.isEmpty else { return nil }
        return orderVM.createOrder(userId: userId, products: productVM.products)
    }
    public func diagnostics() -> String {
        """
        === System Diagnostics ===
        Products loaded: \(productVM.products.count)
        Orders: \(orderVM.orders.count)
        Revenue: \(orderVM.formattedRevenue)
        """
    }
}
