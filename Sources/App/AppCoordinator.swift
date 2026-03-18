import Foundation
import Models
import Networking
import Analytics
protocol QuickOrderProviding { func quickOrder(userId: String, category: String) async -> Order? }
protocol OrderCoordinating { func quickOrder(userId: String, category: String) async -> Order? }
open class AppCoordinator: @unchecked Sendable {
    public let profileVM: UserProfileViewModel?
    public let productVM: ProductListViewModel
    public let orderVM: OrderViewModel
    public init(fetchProducts: @escaping @Sendable (String) async throws -> [Product] = { _ in [] }) { self.profileVM = nil; self.productVM = ProductListViewModel(fetchProducts: fetchProducts); self.orderVM = OrderViewModel() }
    public func quickOrder(userId: String, category: String) async -> Order? { await productVM.loadProducts(category: category); guard !productVM.products.isEmpty else { return nil }; return orderVM.createOrder(userId: userId, products: productVM.products) }
    public func diagnostics() -> String { "=== System Diagnostics ===\nProducts loaded: \(productVM.products.count)\nOrders: \(orderVM.orders.count)\nRevenue: \(orderVM.formattedRevenue)" }
}
extension User {
    public static func fetch(id: String) async throws -> User { try JSONDecoder().decode(User.self, from: try await APIClient.default.fetchUser(id: id)) }
}
extension Product {
    public static func fetchAll(category: String) async throws -> [Product] { try JSONDecoder().decode([Product].self, from: try await APIClient.default.fetchProducts(category: category)) }
    public func loadImage() async throws -> Data { guard let url = imageURL else { return ImageLoader.default.placeholderImageData() }; return try await ImageLoader.default.loadImage(from: url) }
}
extension AnalyticsTracker {
    public func trackUserLogin(user: User) { track(event: "user_login", metadata: ["user_id": user.id, "is_active": "\(user.isActive)", "display_name": user.displayName]) }
    public func trackProductView(product: Product) { track(event: "product_view", metadata: ["product_id": product.id, "category": product.category, "price": product.formattedPrice, "is_on_sale": "\(product.isOnSale)"]) }
    public func trackOrderPlaced(order: Order) { track(event: "order_placed", metadata: ["order_id": order.id, "total": "\(order.total)", "product_count": "\(order.products.count)", "status": order.status.rawValue]) }
}
