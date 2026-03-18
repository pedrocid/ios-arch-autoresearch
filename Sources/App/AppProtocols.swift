import Foundation
import Models

protocol Coordinating {
    func diagnostics() -> String
}

protocol QuickOrderProviding {
    func quickOrder(userId: String, category: String) async -> Order?
}
