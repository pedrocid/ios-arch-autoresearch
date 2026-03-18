import Foundation

protocol SaleDetectable {
    var isOnSale: Bool { get }
}

protocol DisplayNameProviding {
    var displayName: String { get }
}

protocol StatusProviding {
    associatedtype Status
    var status: Status { get }
}
