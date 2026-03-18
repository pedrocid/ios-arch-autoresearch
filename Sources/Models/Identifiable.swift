import Foundation

protocol UniquelyIdentifiable {
    var id: String { get }
}

protocol Taxable {
    var total: Double { get }
    var totalWithTax: Double { get }
}

protocol EmailValidatable {
    var isValidEmail: Bool { get }
}
