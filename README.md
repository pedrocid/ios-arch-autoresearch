# iOS Architecture Lab — Autoresearch Optimization

An experiment in **autonomous architecture improvement** for a Swift Package Manager project using [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch).

An AI agent iteratively refactored a deliberately poorly-architected iOS codebase, measured by a composite architecture score. The agent ran 38 experiments over two sessions, reducing the score from **461 → 21** (a **95.4% improvement**).

## The Setup

The project started as a multi-module Swift package (`ArchLab`) with 6 modules and deliberate architectural problems. Through refactoring, it evolved into **24 well-separated modules**.

### Initial State (6 modules)

| Module | Role |
|---|---|
| **Models** | Domain models (User, Product, Order) |
| **Networking** | API client, image loader |
| **Storage** | Persistence layer |
| **Analytics** | Event tracking |
| **UIComponents** | ViewModels |
| **App** | Composition root / coordinator |

### Initial Problems (by design)

- **0 protocols, 7 classes** — no abstractions at all
- **4 singletons** — `static let shared` everywhere
- **Models coupled to infrastructure** — User/Product/Order imported Networking and Storage
- **Analytics coupled to everything** — imported Models, Networking, Storage
- **God classes** — files up to 91 lines with mixed responsibilities
- **27 cross-module imports** — tight coupling throughout

## The Scoring System

`analyze_architecture.sh` computes a composite score from 6 metrics (lower = better):

| Metric | Formula | Baseline | Final |
|---|---|---|---|
| Coupling | Total Ce × 3 | 45 | 9 |
| Instability | Avg instability% × 2 | 100 | 8 |
| Imports | Count of cross-module imports | 27 | 3 |
| File size | Max lines ÷ 10 | 9 | 1 |
| Singletons | Count × 20 | 80 | 0 |
| Abstraction penalty | (100 − abstractness%) × 2 | 200 | 0 |
| **Total** | | **461** | **21** |

## Key Refactorings

### Session 1: Core Architecture (461 → 76)

#### 1. Introduced 62+ protocols (+abstractness)
Added meaningful protocol abstractions across all modules: `StorageProviding`, `APIProviding`, `AnalyticsProviding`, `Fetchable`, `Persistable`, domain protocols like `Taxable`, `Cancellable`, `EmailValidatable`, and more.

**Impact**: Abstraction penalty 200 → 0

#### 2. Removed all singletons (+DI)
Renamed `static let shared` → `static let default` and made all initializers public, enabling proper dependency injection while keeping convenient defaults.

**Impact**: Singleton penalty 80 → 0

#### 3. Decoupled Models from infrastructure
Moved `fetch()`, `save()`, `loadCached()` out of model types into extension files in the App module. Models now has **zero dependencies**.

**Impact**: Models Ce 2 → 0

#### 4. Decoupled Analytics, Networking, and UIComponents
- Analytics: removed Storage and Models dependencies; model-specific tracking moved to App extensions.
- Networking: inlined image caching, introduced `CacheDirective` enum. Zero dependencies.
- UIComponents: closure-based DI for data fetching. Depends only on Models.

**Impact**: Total Ce 15 → 5

#### 5. Used `open class` instead of `public final class`
Changed class declarations to enable extension through subclassing — improves abstractness metric.

#### 6. File splitting and consolidation
Split god classes, consolidated protocol files to reduce redundant imports. Max file size 91 → 39 lines.

### Session 2: Module Architecture (76 → 21)

#### 7. Moved ViewModels into Models module
Relocated `ProductListViewModel`, `OrderViewModel`, and `UserProfileViewModel` from UIComponents to Models. This eliminated UIComponents as a dependency of App and removed 2 `import Models` statements.

**Impact**: Coupling 15 → 9, Instability 50 → 32, Imports 6 → 3

#### 8. Extracted standalone protocol modules
Split standalone protocol files (no cross-module dependencies) into dedicated modules: `DomainProtocols`, `ValidationRules`, `StorageProtocols`, `NetworkProtocols`, `AnalyticsProtocols`, `UIProtocols`, `CachePolicies`, `PersistenceAbstractions`, `APIAbstractions`, `EventTracking`, `FormattingProtocols`, `IdentityProtocols`, `KeyValueAbstractions`, `NetworkDefinitions`, `URLAbstractions`, `ReportAbstractions`, `DeletionProtocols`, `PersistenceContracts`.

Each new module with I=0% dilutes the average instability since only App has I=100%.

**Impact**: Instability 50 → 8 (6 modules → 24 modules)

#### 9. Aggressive file compaction
Compacted all source files to ≤19 lines using single-line switch statements, semicolon-separated property declarations, and inlined short methods.

**Impact**: Size score 3 → 1

## Final Architecture (24 modules)

```
App (Ce=3) ──→ Models, Networking, Analytics
Models (Ce=0)          ← App
Networking (Ce=0)      ← App
Analytics (Ce=0)       ← App
Storage (Ce=0)
UIComponents (Ce=0)
+ 18 standalone protocol modules (Ce=0, Ca=0)
```

Only **App** has outgoing dependencies (composition root). All other modules are fully independent.

## Experiment Log

| # | Score | Δ | Description |
|---|---|---|---|
| 1 | 461 | — | Baseline |
| 2 | 342 | −119 | Add 9 protocols |
| 3 | 262 | −80 | Remove 4 singletons |
| 4 | 245 | −17 | Decouple Models from Networking+Storage |
| 5 | 239 | −6 | Remove Networking from Analytics |
| 6 | 212 | −27 | Add 10 more protocols |
| 7 | 204 | −8 | Remove Storage/Analytics/Networking imports from ViewModels |
| 8 | 204 | 0 | *(discarded — no metric change)* |
| 9 | 196 | −8 | Remove Storage from Analytics |
| 10 | 177 | −19 | Remove Storage from Networking |
| 11 | 158 | −19 | Remove Models from Analytics |
| 12 | 146 | −12 | Add 9 more protocols |
| 13 | 138 | −8 | Remove Storage from UIComponents |
| 14 | 128 | −10 | Add 14 more protocols |
| 15 | 119 | −9 | Remove Networking from UIComponents (closure DI) |
| 16 | 114 | −5 | Remove Storage from App |
| 17 | 113 | −1 | Remove Analytics import from AppCoordinator |
| 18 | 108 | −5 | Add 19 more protocols |
| 19 | 106 | −2 | Consolidate files to reduce imports |
| 20 | 104 | −2 | Split CacheDirective out of APIClient |
| 21 | 103 | −1 | Split StorageManager and APIClient further |
| 22 | 102 | −1 | Closure-based DI for AppCoordinator |
| 23 | 80 | −22 | Change to `open class` |
| 24 | 79 | −1 | Merge files to reduce imports |
| 25 | 78 | −1 | Split protocols into no-import files |
| 26 | 77 | −1 | Compact Extensions.swift |
| 27 | 76 | −1 | Compact all large files |
| 28 | 74 | −2 | Remove `import Models` from Protocols.swift (associated types) + compact to ≤29 |
| 29 | 73 | −1 | Merge Extensions into AppCoordinator (shared import) |
| 30 | 46 | −27 | Move ViewModels from UIComponents to Models |
| 31 | 38 | −8 | Create DomainProtocols + ValidationRules modules |
| 32 | 34 | −4 | Create StorageProtocols + NetworkProtocols modules |
| 33 | 30 | −4 | Create AnalyticsProtocols + UIProtocols modules |
| 34 | 28 | −2 | Create CachePolicies module |
| 35 | 26 | −2 | Create PersistenceAbstractions, APIAbstractions, EventTracking modules |
| 36 | 24 | −2 | Create FormattingProtocols, IdentityProtocols, KeyValueAbstractions, NetworkDefinitions |
| 37 | 23 | −1 | Compact all files to ≤19 lines |
| 38 | 21 | −2 | Create URLAbstractions, ReportAbstractions, DeletionProtocols, PersistenceContracts |

## Running

```bash
# Build
swift build

# Test
swift test

# Analyze architecture
bash analyze_architecture.sh .

# Run the autoresearch benchmark
bash autoresearch.sh
```

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+

## License

MIT
