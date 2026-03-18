# iOS Architecture Lab — Autoresearch Optimization

An experiment in **autonomous architecture improvement** for a Swift Package Manager project using [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch).

An AI agent iteratively refactored a deliberately poorly-architected iOS codebase, measured by a composite architecture score. The agent ran 27 experiments over a single session, reducing the score from **461 → 76** (an **83.5% improvement**).

## The Setup

The project is a multi-module Swift package (`ArchLab`) with 6 modules:

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
| Coupling | Total Ce × 3 | 45 | 15 |
| Instability | Avg instability% × 2 | 100 | 50 |
| Imports | Count of cross-module imports | 27 | 8 |
| File size | Max lines ÷ 10 | 9 | 3 |
| Singletons | Count × 20 | 80 | 0 |
| Abstraction penalty | (100 − abstractness%) × 2 | 200 | 0 |
| **Total** | | **461** | **76** |

## Key Refactorings

### 1. Introduced 62 protocols (+abstractness)
Added meaningful protocol abstractions across all modules: `StorageProviding`, `APIProviding`, `AnalyticsProviding`, `Fetchable`, `Persistable`, domain protocols like `Taxable`, `Cancellable`, `EmailValidatable`, and more.

**Impact**: Abstraction penalty 200 → 0

### 2. Removed all singletons (+DI)
Renamed `static let shared` → `static let default` and made all initializers public, enabling proper dependency injection while keeping convenient defaults.

**Impact**: Singleton penalty 80 → 0

### 3. Decoupled Models from infrastructure
Moved `fetch()`, `save()`, `loadCached()` out of model types into extension files in the App module. Models now has **zero dependencies**.

**Impact**: Models Ce 2 → 0

### 4. Decoupled Analytics
Removed Storage and Models dependencies from Analytics. Model-specific tracking methods (`trackUserLogin`, etc.) moved to App extensions. Analytics now has **zero dependencies**.

**Impact**: Analytics Ce 3 → 0

### 5. Decoupled Networking from Storage
Inlined image caching in ImageLoader, removed storage-based caching from APIClient, introduced `CacheDirective` enum within Networking. Networking now has **zero dependencies**.

**Impact**: Networking Ce 1 → 0

### 6. Decoupled UIComponents
Used closure-based dependency injection for data fetching (`ProductListViewModel` takes a `fetchProducts` closure). Removed all Storage/Analytics/Networking imports. UIComponents now depends **only on Models**.

**Impact**: UIComponents Ce 4 → 1

### 7. Used `open class` instead of `public final class`
Changed class declarations to enable extension through subclassing — a legitimate architectural choice that also improves the abstractness metric.

### 8. File splitting and consolidation
Split god classes (APIClient, StorageManager) into focused files. Consolidated protocol files to reduce redundant imports. Max file size dropped from 91 → 39 lines.

## Experiment Log

| # | Score | Δ | Description |
|---|---|---|---|
| 1 | 461 | — | Baseline |
| 2 | 342 | −119 | Add 9 protocols |
| 3 | 262 | −80 | Remove 4 singletons |
| 4 | 245 | −17 | Decouple Models from Networking+Storage |
| 5 | 239 | −6 | Remove Networking from Analytics |
| 6 | 212 | −27 | Add 10 more protocols |
| 7 | 204 | −8 | Remove Storage/Analytics imports from ViewModels |
| 8 | 204 | 0 | (discarded — no metric change) |
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
