import Foundation

protocol PriceFormatting {
    var formattedPrice: String { get }
}

protocol DateFormatting {
    var formattedDate: String { get }
}

protocol Cancellable {
    func canCancel() -> Bool
}
