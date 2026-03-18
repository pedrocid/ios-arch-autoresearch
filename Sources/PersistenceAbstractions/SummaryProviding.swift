import Foundation

protocol SummaryProviding {
    func formattedSummary() -> String
}

protocol OperationCounting {
    var operationCount: Int { get }
}
