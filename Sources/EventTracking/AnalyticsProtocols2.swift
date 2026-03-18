import Foundation

protocol EventStoring {
    func track(event: String, metadata: [String: String])
}

protocol EventReporting {
    func generateReport() -> String
}
