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

        // Networking layer - depends on things it shouldn't
        .target(name: "Networking", dependencies: ["Storage"]),

        // Storage/persistence layer
        .target(name: "Storage", dependencies: []),

        // Analytics - coupled to everything
        .target(name: "Analytics", dependencies: ["Models"]),

        // UI Components - knows about infrastructure
        .target(name: "UIComponents", dependencies: ["Models", "Networking", "Analytics", "Storage"]),

        // Main app module
        .target(name: "App", dependencies: ["Models", "Networking", "Storage", "Analytics", "UIComponents"]),

        // Tests - must keep compiling
        .testTarget(name: "AppTests", dependencies: ["App", "Models", "Networking", "Storage", "Analytics", "UIComponents"]),
    ]
)
