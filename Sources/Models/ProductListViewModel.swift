import Foundation

open class ProductListViewModel: @unchecked Sendable {
    public var products: [Product] = []
    public var isLoading: Bool = false
    public var errorMessage: String?
    private let fetchProducts: @Sendable (String) async throws -> [Product]
    public init(fetchProducts: @escaping @Sendable (String) async throws -> [Product] = { _ in [] }) {
        self.fetchProducts = fetchProducts
    }
    public func loadProducts(category: String) async {
        isLoading = true; errorMessage = nil
        do { products = try await fetchProducts(category) }
        catch { errorMessage = "Failed to load products: \(error.localizedDescription)" }
        isLoading = false
    }
    public var saleProducts: [Product] { products.filter { $0.isOnSale } }
    public var headerText: String {
        if isLoading { return "Loading..." }
        if let error = errorMessage { return error }
        return "Showing \(products.count) products (\(saleProducts.count) on sale)"
    }
}
