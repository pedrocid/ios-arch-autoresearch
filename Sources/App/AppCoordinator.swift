import Foundation
import Models
import Networking
import Storage
import Analytics
import UIComponents

// BAD: God coordinator that knows about everything
public final class AppCoordinator: @unchecked Sendable {
    public let profileVM: UserProfileViewModel?
    public let productVM: ProductListViewModel
    public let orderVM: OrderViewModel

    public init() {
        self.profileVM = nil
        self.productVM = ProductListViewModel()
        self.orderVM = OrderViewModel()
    }

    // BAD: Coordinator does business logic
    public func quickOrder(userId: String, category: String) async -> Order? {
        await productVM.loadProducts(category: category)

        guard !productVM.products.isEmpty else { return nil }

        let order = orderVM.createOrder(userId: userId, products: productVM.products)

        // BAD: Direct analytics call
        AnalyticsTracker.default.track(event: "quick_order", metadata: [
            "user_id": userId,
            "category": category,
            "order_id": order.id
        ])

        // BAD: Direct storage call
        StorageManager.default.save(key: "last_quick_order", value: order.id)

        return order
    }

    // BAD: System diagnostics in coordinator
    public func diagnostics() -> String {
        """
        === System Diagnostics ===
        API: \(APIClient.default.statusDescription())
        Storage: \(StorageManager.default.formattedSummary())
        Products loaded: \(productVM.products.count)
        Orders: \(orderVM.orders.count)
        Revenue: \(orderVM.formattedRevenue)
        \(AnalyticsTracker.default.generateReport())
        """
    }
}
