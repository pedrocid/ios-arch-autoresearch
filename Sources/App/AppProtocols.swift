import Foundation
import Models

protocol Coordinating {
    func diagnostics() -> String
}

protocol QuickOrderProviding {
    func quickOrder(userId: String, category: String) async -> Order?
}

protocol OrderCoordinating {
    func quickOrder(userId: String, category: String) async -> Order?
}

protocol ViewModelProviding {
    associatedtype ProductVM
    associatedtype OrderVM
    var productVM: ProductVM { get }
    var orderVM: OrderVM { get }
}

protocol DiagnosticsProviding {
    func diagnostics() -> String
}

protocol SystemStatusProviding {
    func statusDescription() -> String
}
