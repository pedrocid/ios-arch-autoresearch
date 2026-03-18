import Testing
import Foundation
@testable import Models
@testable import Storage
@testable import Networking
@testable import Analytics
@testable import UIComponents
@testable import App

@Suite("Architecture Lab - Core Tests")
struct ArchitectureTests {

    @Test("User model creation")
    func userCreation() {
        let user = User(id: "1", name: "Pedro", email: "pedro@example.com")
        #expect(user.id == "1")
        #expect(user.name == "Pedro")
        #expect(user.isActive)
        #expect(user.displayName == "Pedro")
    }

    @Test("User email validation")
    func userEmailValidation() {
        let validUser = User(id: "1", name: "Test", email: "test@example.com")
        #expect(validUser.isValidEmail)

        let invalidUser = User(id: "2", name: "Test", email: "invalid")
        #expect(!invalidUser.isValidEmail)
    }

    @Test("Inactive user display name")
    func inactiveUserDisplayName() {
        let user = User(id: "1", name: "Pedro", email: "pedro@example.com", isActive: false)
        #expect(user.displayName == "Pedro (inactive)")
    }

    @Test("Product model creation")
    func productCreation() {
        let product = Product(id: "p1", name: "Widget", price: 29.99, category: "electronics")
        #expect(product.id == "p1")
        #expect(product.formattedPrice == "$29.99")
        #expect(!product.isOnSale)
    }

    @Test("Product sale detection")
    func productSaleDetection() {
        let clearance = Product(id: "p1", name: "Cheap", price: 5.0, category: "clearance")
        #expect(clearance.isOnSale)

        let cheap = Product(id: "p2", name: "Budget", price: 9.99, category: "general")
        #expect(cheap.isOnSale)

        let normal = Product(id: "p3", name: "Normal", price: 50.0, category: "general")
        #expect(!normal.isOnSale)
    }

    @Test("Order total calculation")
    func orderTotal() {
        let products = [
            Product(id: "1", name: "A", price: 10.0, category: "cat"),
            Product(id: "2", name: "B", price: 20.0, category: "cat"),
        ]
        let order = Order(id: "o1", userId: "u1", products: products)
        #expect(order.total == 30.0)
        #expect(order.totalWithTax == 30.0 * 1.21)
    }

    @Test("Order cancellation rules")
    func orderCancellation() {
        let pending = Order(id: "1", userId: "u1", products: [], status: .pending)
        #expect(pending.canCancel())

        let confirmed = Order(id: "2", userId: "u1", products: [], status: .confirmed)
        #expect(confirmed.canCancel())

        let shipped = Order(id: "3", userId: "u1", products: [], status: .shipped)
        #expect(!shipped.canCancel())

        let delivered = Order(id: "4", userId: "u1", products: [], status: .delivered)
        #expect(!delivered.canCancel())
    }

    @Test("Storage key validation")
    func storageKeyValidation() {
        let storage = StorageManager.default
        #expect(storage.isValidKey("valid_key"))
        #expect(storage.isValidKey("user123"))
        #expect(!storage.isValidKey(""))
        #expect(!storage.isValidKey("key with spaces"))
    }

    @Test("Storage operations")
    func storageOperations() {
        let storage = StorageManager.default
        storage.clear()

        storage.save(key: "test", value: "hello")
        let loaded = storage.load(key: "test") as? String
        #expect(loaded == "hello")

        storage.delete(key: "test")
        #expect(storage.load(key: "test") == nil)
    }

    @Test("Cache policy HTTP headers")
    func cachePolicyHeaders() {
        #expect(CachePolicy.never.httpHeaderValue == "no-cache, no-store")
        #expect(CachePolicy.always.httpHeaderValue == "max-age=31536000")
        #expect(CachePolicy.duration(60).httpHeaderValue == "max-age=60")
    }

    @Test("Cache policy display names")
    func cachePolicyDisplayNames() {
        #expect(CachePolicy.never.displayName == "No caching")
        #expect(CachePolicy.always.displayName == "Cache forever")
    }

    @Test("Analytics tracking")
    func analyticsTracking() {
        let tracker = AnalyticsTracker.default
        let user = User(id: "1", name: "Test", email: "test@test.com")
        tracker.trackUserLogin(user: user)
        // Just verify it doesn't crash - the coupling is the problem we're measuring
    }

    @Test("ProductListViewModel initial state")
    func productListInitialState() {
        let vm = ProductListViewModel()
        #expect(vm.products.isEmpty)
        #expect(!vm.isLoading)
        #expect(vm.errorMessage == nil)
    }

    @Test("OrderViewModel creation")
    func orderViewModelCreation() {
        let vm = OrderViewModel()
        let products = [Product(id: "1", name: "Test", price: 10.0, category: "cat")]
        let order = vm.createOrder(userId: "user1", products: products)
        #expect(order.userId == "user1")
        #expect(order.products.count == 1)
        #expect(vm.orders.count == 1)
    }

    @Test("AppCoordinator initialization")
    func appCoordinatorInit() {
        let coordinator = AppCoordinator()
        #expect(coordinator.productVM.products.isEmpty)
        #expect(coordinator.orderVM.orders.isEmpty)
    }
}
