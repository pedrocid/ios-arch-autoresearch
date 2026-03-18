import Foundation
import Models
import Networking
import Analytics

extension User {
    public static func fetch(id: String) async throws -> User { try JSONDecoder().decode(User.self, from: try await APIClient.default.fetchUser(id: id)) }
}
extension Product {
    public static func fetchAll(category: String) async throws -> [Product] { try JSONDecoder().decode([Product].self, from: try await APIClient.default.fetchProducts(category: category)) }
    public func loadImage() async throws -> Data {
        guard let url = imageURL else { return ImageLoader.default.placeholderImageData() }
        return try await ImageLoader.default.loadImage(from: url)
    }
}
extension AnalyticsTracker {
    public func trackUserLogin(user: User) { track(event: "user_login", metadata: ["user_id": user.id, "is_active": "\(user.isActive)", "display_name": user.displayName]) }
    public func trackProductView(product: Product) { track(event: "product_view", metadata: ["product_id": product.id, "category": product.category, "price": product.formattedPrice, "is_on_sale": "\(product.isOnSale)"]) }
    public func trackOrderPlaced(order: Order) { track(event: "order_placed", metadata: ["order_id": order.id, "total": "\(order.total)", "product_count": "\(order.products.count)", "status": order.status.rawValue]) }
}
