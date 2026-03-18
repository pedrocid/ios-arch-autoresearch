import Foundation

protocol Coordinating {
    func diagnostics() -> String
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
