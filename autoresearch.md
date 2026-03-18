# Autoresearch: iOS Architecture Improvement

## Objective
Improve the architecture of a Swift SPM project by reducing coupling, removing singletons, introducing protocols/abstractions, and cleaning up responsibilities. The composite score from `analyze_architecture.sh` measures architecture quality (lower = better).

## Metrics
- **Primary**: arch_score (unitless, lower is better)
- **Secondary**: coupling, instability, imports, singletons, abstraction_penalty, size_score

## How to Run
`./autoresearch.sh` — builds, analyzes architecture, outputs `METRIC name=value` lines.

## Files in Scope
- `Sources/Models/User.swift` — User model, coupled to Networking+Storage
- `Sources/Models/Product.swift` — Product model, coupled to Networking+Storage
- `Sources/Models/Order.swift` — Order model, coupled to Storage
- `Sources/Networking/APIClient.swift` — API client singleton, coupled to Storage
- `Sources/Networking/ImageLoader.swift` — Image loader singleton, coupled to Storage
- `Sources/Storage/StorageManager.swift` — Storage singleton/god class
- `Sources/Storage/CachePolicy.swift` — Cache policy enum with too many responsibilities
- `Sources/Analytics/AnalyticsTracker.swift` — Analytics singleton, coupled to everything
- `Sources/UIComponents/ProductListViewModel.swift` — ViewModel coupled to everything
- `Sources/UIComponents/OrderViewModel.swift` — ViewModel coupled to everything
- `Sources/UIComponents/UserProfileView.swift` — ViewModel coupled to everything
- `Sources/App/AppCoordinator.swift` — God coordinator
- `Package.swift` — Module dependency declarations
- `Tests/AppTests/ArchitectureTests.swift` — Tests that must keep passing

## Off Limits
- `analyze_architecture.sh` — the scoring script, do not modify
- `autoresearch.sh` — the benchmark runner

## Constraints
- Tests must pass (`swift test`)
- Project must build (`swift build`)
- All existing public API behavior must be preserved (tests verify this)
- Can add new files/modules but not external dependencies

## Score Breakdown (baseline = 461)
- Coupling (Ce×3): 45 — reduce by removing cross-module dependencies
- Instability (avg×2): 100 — balance Ce/Ca ratios
- Imports: 27 — reduce cross-module import statements
- Max file size (/10): 9 — split large files
- Singletons (×20): 80 — remove `static let shared` patterns (4 singletons)
- Abstraction penalty: 200 — add protocols (0 protocols, 7 classes → 0% abstractness)

## Strategy
1. **Protocols first** — biggest win (200 → lower). Add protocols for key abstractions.
2. **Remove singletons** — 80 points. Use dependency injection instead.
3. **Decouple Models** — Remove imports of Networking/Storage from Models module.
4. **Decouple modules** — Reduce efferent coupling, especially in Package.swift dependencies.
5. **Split large files** — Minor but helps.

## What's Been Tried
(nothing yet — baseline is 461)
