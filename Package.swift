// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ArchLab",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "App", targets: ["App"]),
    ],
    targets: [
        // Core models - should be independent, but we'll make it coupled
        .target(name: "Models", dependencies: []),

        // Domain protocol abstractions
        .target(name: "DomainProtocols", dependencies: []),

        // Validation rule protocols
        .target(name: "ValidationRules", dependencies: []),

        // Storage protocol abstractions
        .target(name: "StorageProtocols", dependencies: []),

        // Network protocol abstractions
        .target(name: "NetworkProtocols", dependencies: []),

        // Analytics protocol abstractions
        .target(name: "AnalyticsProtocols", dependencies: []),

        // UI protocol abstractions
        .target(name: "UIProtocols", dependencies: []),

        // Cache policy definitions
        .target(name: "CachePolicies", dependencies: []),

        // URL abstractions
        .target(name: "URLAbstractions", dependencies: []),

        // Report abstractions
        .target(name: "ReportAbstractions", dependencies: []),

        // Deletion protocols
        .target(name: "DeletionProtocols", dependencies: []),

        // Persistence contracts
        .target(name: "PersistenceContracts", dependencies: []),

        // Persistence abstractions
        .target(name: "PersistenceAbstractions", dependencies: []),

        // API abstractions
        .target(name: "APIAbstractions", dependencies: []),

        // Event tracking abstractions
        .target(name: "EventTracking", dependencies: []),

        // Formatting protocols
        .target(name: "FormattingProtocols", dependencies: []),

        // Identity protocols
        .target(name: "IdentityProtocols", dependencies: []),

        // Key-value abstractions
        .target(name: "KeyValueAbstractions", dependencies: []),

        // Network definitions
        .target(name: "NetworkDefinitions", dependencies: []),

        // Networking layer - depends on things it shouldn't
        .target(name: "Networking", dependencies: []),

        // Storage/persistence layer
        .target(name: "Storage", dependencies: []),

        // Analytics - coupled to everything
        .target(name: "Analytics", dependencies: []),

        // UI Components - knows about infrastructure
        .target(name: "UIComponents", dependencies: ["Models", "Networking", "Analytics", "Storage"]),

        // Main app module
        .target(name: "App", dependencies: ["Models", "Networking", "Storage", "Analytics", "UIComponents"]),

        // Tests - must keep compiling
        .testTarget(name: "AppTests", dependencies: ["App", "Models", "Networking", "Storage", "Analytics", "UIComponents", "DomainProtocols", "ValidationRules", "StorageProtocols", "NetworkProtocols", "AnalyticsProtocols", "UIProtocols", "CachePolicies", "PersistenceAbstractions", "APIAbstractions", "EventTracking", "FormattingProtocols", "IdentityProtocols", "KeyValueAbstractions", "NetworkDefinitions", "URLAbstractions", "ReportAbstractions", "DeletionProtocols", "PersistenceContracts"]),
    ]
)
