import Foundation

protocol DiagnosticsProviding {
    func diagnostics() -> String
}

protocol SystemStatusProviding {
    func statusDescription() -> String
}
