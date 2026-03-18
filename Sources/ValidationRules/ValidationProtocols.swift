import Foundation

protocol Validatable {
    var isValid: Bool { get }
}

protocol OrderValidation {
    func canCancel() -> Bool
}

protocol TotalCalculating {
    var total: Double { get }
    var totalWithTax: Double { get }
    var formattedTotal: String { get }
}

protocol CategoryProviding {
    var category: String { get }
}
