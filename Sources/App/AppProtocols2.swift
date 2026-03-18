import Foundation
import Models

protocol OrderCoordinating {
    func quickOrder(userId: String, category: String) async -> Order?
}

protocol ViewModelProviding {
    associatedtype ProductVM
    associatedtype OrderVM
    var productVM: ProductVM { get }
    var orderVM: OrderVM { get }
}
