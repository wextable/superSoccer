# System Patterns

## Architecture Overview
SuperSoccer follows a clean, layered architecture with strict separation of concerns and dependency inversion principles.

## Core Architectural Patterns

### 1. Clean Data Architecture (3-Layer)
```
SwiftDataStorage (Persistence) → DataManager (Orchestration) → Transformers (Translation)
```

**Layer Responsibilities:**
- **SwiftDataStorage**: Pure SwiftData operations, database transactions, no Client model knowledge
- **DataManager**: Orchestrates between transformers and storage, exposes only Client models
- **Transformers**: Pure translation logic between Client and SwiftData models

**Key Principle**: SwiftData models never leave storage layer, Client models never enter storage layer

### 2. Coordinator Pattern
```
RootCoordinator → FeatureCoordinators → BaseFeatureCoordinator<Result>
```

**Structure:**
- **BaseFeatureCoordinator<Result>**: Generic base with automatic child management
- **Feature-Specific Results**: Each coordinator defines its own Result enum
- **Navigation Delegation**: NavigationCoordinator handles actual navigation operations
- **Child Management**: `startChild()` for automatic lifecycle management

### 3. Feature Architecture Pattern
```
Features/[FeatureName]/
├── [FeatureName]FeatureCoordinator.swift
├── [FeatureName]Interactor.swift
├── [FeatureName]View.swift
├── [FeatureName]LocalDataSource.swift (if needed)
└── Supporting files (ViewModels, etc.)
```

**Responsibilities:**
- **Coordinator**: Navigation flow and feature lifecycle
- **Interactor**: Business logic and data coordination
- **View**: Presentation layer with ViewModels for state
- **LocalDataSource**: Feature-specific data operations

### 4. Dependency Injection Pattern
```
DependencyContainer.shared → Protocol-based dependencies → Mock implementations
```

**Key Elements:**
- **Protocol Abstractions**: All dependencies are protocol-based
- **Mock Implementations**: Every protocol has a Mock version in #if DEBUG blocks
- **Constructor Injection**: Dependencies injected through initializers
- **Testability**: Easy swapping for unit tests

## Data Flow Patterns

### Request/Result Pattern
Used for complex operations requiring structured input/output:
```swift
CreateNewCareerRequest → DataManager → CreateNewCareerResult
```

### Publisher Pattern
Reactive UI updates using Combine:
```swift
DataManager.careerPublisher → UI automatically updates
```

### Transformation Pattern
Bidirectional model conversion:
```swift
Client Models ↔ Transformers ↔ SwiftData Models
```

## Navigation Patterns

### Coordinator Result Pattern
```swift
enum TeamSelectCoordinatorResult {
    case teamSelected(Team)
    case cancelled
}
```

### Child Coordinator Management
```swift
let childCoordinator = startChild(TeamSelectFeatureCoordinator.self)
childCoordinator.delegate = self
```

## Event-Driven Patterns

### EventBus Pattern
Feature-specific event communication:
```swift
TeamSelectEventBus.shared.send(.teamSelected(team))
```

### Delegate Pattern
Coordinator communication:
```swift
protocol TeamSelectCoordinatorDelegate: AnyObject {
    func teamSelectCoordinator(_ coordinator: TeamSelectFeatureCoordinator, didSelectTeam team: Team)
}
```

## Model Design Patterns

### Client Model Pattern
- Immutable structs with `let` properties
- Conform to `Identifiable`, `Hashable`, `Equatable`
- ID-based relationships (String IDs) to prevent circular dependencies

### SwiftData Model Pattern
- `@Model` classes with mutable properties
- Direct object relationships for persistence
- Prefixed with `SD` (SDTeam, SDPlayer, etc.)

### Transformation Bundle Pattern
For complex entity creation:
```swift
struct CareerCreationBundle {
    let career: SDCareer
    let league: SDLeague
    let season: SDSeason
    let teams: [SDTeam]
    let players: [SDPlayer]
    let coaches: [SDCoach]
}
```

## Testing Patterns

### Mock Pattern
```swift
#if DEBUG
class MockDataManager: DataManagerProtocol {
    // Mock implementation
}
#endif
```

### Protocol Abstraction Pattern
Every service has a protocol for testability:
```swift
protocol DataManagerProtocol {
    func createNewCareer(_ request: CreateNewCareerRequest) async throws -> CreateNewCareerResult
}
```

## Key Design Principles

1. **Single Responsibility**: Each class has one clear purpose
2. **Dependency Inversion**: Depend on abstractions, not concretions
3. **Open/Closed**: Easy to extend without modifying existing code
4. **Interface Segregation**: Clean, focused interfaces
5. **Don't Repeat Yourself**: Centralized transformation and business logic

## Critical Implementation Rules

### Model Boundaries
- Client models must never cross into SwiftData layer
- SwiftData models must never escape storage layer
- Transformers are the only bridge between model types

### Navigation Flow
- All navigation goes through NavigationCoordinator
- Views never perform navigation directly
- Coordinators manage feature lifecycle and results

### Dependency Management
- All dependencies injected through constructors
- No singleton access except DependencyContainer.shared
- Protocol-based design for all services

### Error Handling
- Use proper Swift error handling with throws/async throws
- Handle errors at appropriate layers
- Provide meaningful error messages

This pattern system ensures maintainable, testable, and scalable architecture for the SuperSoccer application.
