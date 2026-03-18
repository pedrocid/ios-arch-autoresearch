import Foundation
import Models

protocol AnalyticsProviding {
    func track(event: String, metadata: [String: String])
    func generateReport() -> String
}

protocol EventTracking {
    func trackUserLogin(user: User)
    func trackProductView(product: Product)
    func trackOrderPlaced(order: Order)
}
