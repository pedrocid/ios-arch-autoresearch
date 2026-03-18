import Foundation
import Models
import UIComponents

open class AppCoordinator: @unchecked Sendable {
    public let profileVM: UserProfileViewModel?
    public let productVM: ProductListViewModel
    public let orderVM: OrderViewModel

    public init(fetchProducts: @escaping @Sendable (String) async throws -> [Product] = { _ in [] }) {
        self.profileVM = nil
        self.productVM = ProductListViewModel(fetchProducts: fetchProducts)
        self.orderVM = OrderViewModel()
    }

    public func quickOrder(userId: String, category: String) async -> Order? {
        await productVM.loadProducts(category: category)

        guard !productVM.products.isEmpty else { return nil }

        let order = orderVM.createOrder(userId: userId, products: productVM.products)
        return order
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
