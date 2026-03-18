import Foundation
import Models
import Analytics

extension AnalyticsTracker {
    public func trackUserLogin(user: User) {
        track(event: "user_login", metadata: [
            "user_id": user.id,
            "is_active": "\(user.isActive)",
            "display_name": user.displayName
        ])
    }

    public func trackProductView(product: Product) {
        track(event: "product_view", metadata: [
            "product_id": product.id,
            "category": product.category,
            "price": product.formattedPrice,
            "is_on_sale": "\(product.isOnSale)"
        ])
    }

    public func trackOrderPlaced(order: Order) {
        track(event: "order_placed", metadata: [
            "order_id": order.id,
            "total": "\(order.total)",
            "product_count": "\(order.products.count)",
            "status": order.status.rawValue
        ])
    }
}
