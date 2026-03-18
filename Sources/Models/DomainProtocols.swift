import Foundation

protocol SaleDetectable {
    var isOnSale: Bool { get }
}

protocol DisplayNameProviding {
    var displayName: String { get }
}

protocol StatusProviding {
    var status: Order.OrderStatus { get }
}
