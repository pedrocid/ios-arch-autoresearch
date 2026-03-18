import Foundation
import Models
import Networking
import Analytics
import Storage

// BAD: Another ViewModel tightly coupled to everything
public final class ProductListViewModel: @unchecked Sendable {
    public var products: [Product] = []
    public var isLoading: Bool = false
    public var errorMessage: String?

    public init() {}

    // BAD: ViewModel directly manages network calls, caching, and analytics
    public func loadProducts(category: String) async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await Product.fetchAll(category: category)

            // BAD: Caching logic in ViewModel
            for product in products {
                product.save()
            }

            // BAD: Analytics tracking in ViewModel
            for product in products {
                AnalyticsTracker.shared.trackProductView(product: product)
            }

            // BAD: Direct storage access
            StorageManager.shared.save(key: "last_category", value: category)

        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            // BAD: ViewModel stores errors in global storage
            StorageManager.shared.save(key: "last_error", value: errorMessage as Any)
        }

        isLoading = false
    }

    // BAD: Business logic in ViewModel
    public var saleProducts: [Product] {
        products.filter { $0.isOnSale }
    }

    // BAD: Formatting in ViewModel that should be in View
    public var headerText: String {
        if isLoading { return "Loading..." }
        if let error = errorMessage { return error }
        return "Showing \(products.count) products (\(saleProducts.count) on sale)"
    }

    // BAD: Report generation in ViewModel
    public func fullReport() -> String {
        AnalyticsTracker.shared.generateReport()
    }
}
