import Foundation

protocol ErrorDisplayable {
    var errorMessage: String? { get }
}

protocol Selectable {
    associatedtype Item
    var selectedOrder: Item? { get }
}

protocol SaleFiltering {
    associatedtype Product
    var saleProducts: [Product] { get }
}
