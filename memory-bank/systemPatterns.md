# System Patterns

## Architecture Overview
SuperSoccer follows a clean, layered architecture with strict separation of concerns, dependency inversion principles, and type-safe dependency injection through the InteractorFactory pattern.

## Core Architectural Patterns

### 1. InteractorFactory Pattern
```
InteractorFactoryProtocol → InteractorFactory (Production) / MockInteractorFactory (Testing)
                         ↓
               Feature Coordinators → Interactors
```

**Structure:**
- **InteractorFactoryProtocol**: Defines factory methods for all interactor creation
- **InteractorFactory**: Production implementation with DataManager dependency injection
- **MockInteractorFactory**: Testing implementation with pre-configured mock interactors
- **Parameterized Support**: Factory methods support both simple and parameterized interactor creation

**Example:**
```swift
protocol InteractorFactoryProtocol {
    // Simple interactors (no additional parameters)
    func makeNewGameInteractor() -> NewGameInteractorProtocol
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    
    // Parameterized interactors (context-specific parameters)
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol
}

class InteractorFactory: InteractorFactoryProtocol {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol {
        return TeamInteractor(userTeamId: userTeamId, dataManager: dataManager)
    }
}
```

### 2. Clean Data Architecture (3-Layer)
```
SwiftDataStorage (Persistence) → DataManager (Orchestration) → Transformers (Translation)
```

**Layer Responsibilities:**
- **SwiftDataStorage**: Pure SwiftData operations, database transactions, no Client model knowledge
- **DataManager**: Orchestrates between transformers and storage, exposes only Client models
- **Transformers**: Pure translation logic between Client and SwiftData models

**Key Principle**: SwiftData models never leave storage layer, Client models never enter storage layer

### 3. Async/Await DataManager Pattern ✨
```
@MainActor DataManager Methods → Swift 6 Concurrency → Sendable Protocols
```

**Modern Concurrency Architecture:**
- **Async Use-Case Methods**: Replace complex Combine chains with simple async functions
- **MainActor Threading**: DataManager methods handle their own threading requirements
- **Sendable Compliance**: All protocols conform to `Sendable` for concurrency safety
- **Zero Swift 6 Warnings**: Complete migration to modern concurrency patterns

**Example:**
```swift
protocol DataManagerProtocol: Sendable {
    // Traditional reactive publishers (maintained for compatibility)
    var teamPublisher: AnyPublisher<[Team], Never> { get }
    var playerPublisher: AnyPublisher<[Player], Never> { get }
    var coachPublisher: AnyPublisher<[Coach], Never> { get }
    
    // NEW: Modern async use-case methods
    @MainActor
    func getTeamDetails(teamId: String) async -> (team: Team?, coach: Coach?, players: [Player])
}

final class SwiftDataManager: DataManagerProtocol, @unchecked Sendable {
    @MainActor
    func getTeamDetails(teamId: String) async -> (team: Team?, coach: Coach?, players: [Player]) {
        // Single use-case method replaces complex 3-publisher Combine chain
        let sdTeam = storage.fetchTeam(by: teamId)
        let team = sdTeam.map(swiftDataToClientTransformer.transform)
        
        let sdCoach = sdTeam?.coachId.flatMap(storage.fetchCoach)
        let coach = sdCoach.map(swiftDataToClientTransformer.transform)
        
        let sdPlayers = sdTeam?.playerIds.compactMap(storage.fetchPlayer) ?? []
        let players = sdPlayers.map(swiftDataToClientTransformer.transform)
        
        return (team: team, coach: coach, players: players)
    }
}
```

**Concurrency Benefits:**
- **Simpler Code**: Single async call vs complex publisher chains
- **Better Error Handling**: Native async throws vs Combine error types  
- **Threading Clarity**: Clear `@MainActor` vs complex scheduler juggling
- **Swift 6 Ready**: Native concurrency support without compatibility issues

### 4. MainActor Observable Interactor Pattern ✨
```
@MainActor @Observable Interactor → Async DataManager → UI Reactivity
```

**Modern Interactor Architecture:**
```swift
@MainActor @Observable
class TeamInteractor: TeamInteractorProtocol {
    var viewModel = TeamViewModel()
    private let dataManager: DataManagerProtocol
    
    private func loadTeamData() async {
        let details = await dataManager.getTeamDetails(teamId: userTeamId)
        updateViewModel(details) // @Observable handles UI updates automatically
    }
}
```

**Key Patterns:**
- **@MainActor**: Ensures all UI-related operations happen on main thread
- **@Observable**: Provides reactive UI updates without `@Published` properties
- **Async Methods**: Replace complex Combine subscriptions with simple async calls
- **Direct Function Calls**: No Task closures or background threading complexity

### 5. Simplified Mock Testing Pattern ✨
```
MockDataManager.mockEntityDetails → Direct Test Control → No Array Filtering
```

**Enhanced Testing Architecture:**
```swift
class MockDataManager: DataManagerProtocol {
    // OLD: Complex filtering through arrays
    @Published var mockTeams: [Team] = []
    @Published var mockCoaches: [Coach] = []
    @Published var mockPlayers: [Player] = []
    
    // NEW: Direct control with simple properties
    var mockTeamDetails: (team: Team?, coach: Coach?, players: [Player]) = (nil, nil, [])
    
    @MainActor
    func getTeamDetails(teamId: String) async -> (team: Team?, coach: Coach?, players: [Player]) {
        return mockTeamDetails // Direct return, no filtering logic
    }
}
```

**Testing Benefits:**
- **One-line setup**: `mockDataManager.mockTeamDetails = (team, coach, players)`
- **Direct control**: Tests specify exactly what method returns
- **No filtering logic**: Eliminates complex array operations in tests
- **Clearer intent**: Test setup directly matches what's being tested

### 6. Coordinator Pattern with Factory Integration
```
RootCoordinator → FeatureCoordinators (with InteractorFactory) → BaseFeatureCoordinator<r>
```

**Structure:**
- **BaseFeatureCoordinator<r>**: Generic base with automatic child management
- **Feature-Specific Results**: Each coordinator defines its own Result enum
- **Navigation Delegation**: NavigationCoordinator handles actual navigation operations
- **InteractorFactory Integration**: All coordinators use factory for interactor creation
- **Child Management**: `startChild()` for automatic lifecycle management

### 7. Feature Architecture Pattern
```
Features/[FeatureName]/
├── [FeatureName]FeatureCoordinator.swift (uses InteractorFactory)
├── [FeatureName]Interactor.swift (created by factory)
├── [FeatureName]View.swift
├── [FeatureName]LocalDataSource.swift (if needed)
└── Supporting files (ViewModels, etc.)
```

**Responsibilities:**
- **Coordinator**: Navigation flow, feature lifecycle, and interactor creation via factory
- **Interactor**: Business logic and data coordination (factory-created)
- **View**: Presentation layer with ViewModels for state
- **LocalDataSource**: Feature-specific data operations

### 8. Dependency Injection Pattern with Factory
```
DependencyContainer.shared → InteractorFactory → Protocol-based dependencies → Mock implementations
```

**Key Elements:**
- **InteractorFactory**: Type-safe factory for all interactor creation
- **Protocol Abstractions**: All dependencies are protocol-based
- **Mock Implementations**: Every protocol has a Mock version in #if DEBUG blocks
- **Constructor Injection**: Dependencies injected through factory-created instances
- **Testability**: Easy swapping for unit tests via MockInteractorFactory

## Data Flow Patterns

### Async Use-Case Pattern ✨ 
**Modern approach** replacing complex Combine chains:
```swift
// OLD: Complex Combine chain
dataManager.teamPublisher
    .combineLatest(dataManager.coachPublisher, dataManager.playerPublisher)
    .map { teams, coaches, players in
        // Complex filtering and mapping logic
    }
    .sink { [weak self] in
        self?.updateUI($0)
    }

// NEW: Simple async call
let teamDetails = await dataManager.getTeamDetails(teamId: userTeamId)
updateViewModel(teamDetails)
```

### Request/Result Pattern
Used for complex operations requiring structured input/output:
```swift
CreateNewCareerRequest → DataManager → CreateNewCareerResult
```

### Publisher Pattern
Reactive UI updates using Combine (maintained for compatibility):
```swift
DataManager.careerPublisher → UI automatically updates
```

### Transformation Pattern
Bidirectional model conversion:
```swift
Client Models ↔ Transformers ↔ SwiftData Models
```

## Navigation Patterns with InteractorFactory

### Coordinator Result Pattern with Factory Integration
```swift
enum TeamSelectCoordinatorResult: CoordinatorResult {
    case teamSelected(Team)
    case cancelled
}

class TeamSelectFeatureCoordinator: BaseFeatureCoordinator<TeamSelectCoordinatorResult> {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let interactorFactory: InteractorFactoryProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.interactorFactory = interactorFactory
        super.init()
    }
    
    override func start() {
        let interactor = interactorFactory.makeTeamSelectInteractor()
        interactor.delegate = self
        
        let screen = NavigationRouter.Screen.teamSelect(interactor: interactor)
        Task { @MainActor in
            self.navigationCoordinator.presentSheet(screen)
        }
    }
}

extension TeamSelectFeatureCoordinator: TeamSelectInteractorDelegate {
    func teamSelected(_ team: Team) {
        finish(with: .teamSelected(team))
    }
}
```

### Parameterized Interactor Pattern
```swift
class TeamFeatureCoordinator: BaseFeatureCoordinator<TeamCoordinatorResult> {
    private let userTeamId: String
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let interactorFactory: InteractorFactoryProtocol
    
    init(userTeamId: String,
         navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.userTeamId = userTeamId
        self.navigationCoordinator = navigationCoordinator
        self.interactorFactory = interactorFactory
        super.init()
    }
    
    override func start() {
        let interactor = interactorFactory.makeTeamInteractor(userTeamId: userTeamId)
        interactor.delegate = self
        
        let screen = NavigationRouter.Screen.team(interactor: interactor)
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(screen)
        }
    }
}
```

### Child Coordinator Management with Factory
```swift
// Starting a child coordinator with factory-based interactor creation
let childCoordinator = TeamSelectFeatureCoordinator(
    navigationCoordinator: navigationCoordinator,
    interactorFactory: interactorFactory
)

startChild(childCoordinator) { [weak self] result in
    switch result {
    case .teamSelected(let team):
        self?.handleTeamSelected(team)
    case .cancelled:
        self?.handleCancellation()
    }
    // Automatic cleanup happens in BaseFeatureCoordinator
}
```

## Event-Driven Patterns

### EventBus Pattern with Factory-Created Interactors
Feature-specific event communication for factory-created interactors:
```swift
typealias TeamSelectEventBus = PassthroughSubject<TeamSelectEvent, Never>

enum TeamSelectEvent: BusEvent {
    case loadTeams
    case teamSelected(teamId: String)
}

class TeamSelectInteractor: TeamSelectInteractorProtocol {
    let eventBus = TeamSelectEventBus()
    
    // Created by InteractorFactory with proper dependency injection
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .loadTeams:
                    self?.loadTeams()
                case .teamSelected(let teamId):
                    self?.handleTeamSelected(teamId)
                }
            }
            .store(in: &cancellables)
    }
}

// Usage in View with factory-created interactor
Button("Select Team") {
    interactor.eventBus.send(.teamSelected(teamId: "team1"))
}
```

### Delegate Pattern with Factory Integration
Coordinator communication using factory-created interactors:
```swift
protocol TeamSelectInteractorDelegate: AnyObject {
    func teamSelected(_ team: Team)
}

class TeamSelectInteractor: TeamSelectInteractorProtocol {
    weak var delegate: TeamSelectInteractorDelegate?
    
    // Factory ensures proper initialization with dependencies
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    private func handleTeamSelected(_ teamId: String) {
        let team = dataManager.fetchTeam(id: teamId)
        delegate?.teamSelected(team)
    }
}
```

## Testing Patterns with InteractorFactory

### MockDependencyContainer Pattern
Unified testing interface using factory pattern:
```swift
class MockDependencyContainer {
    let mockInteractorFactory = MockInteractorFactory()
    let mockNavigationCoordinator = MockNavigationCoordinator()
    
    // Factory methods for coordinator creation in tests
    func makeTeamCoordinator(userTeamId: String) -> TeamFeatureCoordinator {
        return TeamFeatureCoordinator(
            userTeamId: userTeamId,
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
    
    func makeMainMenuCoordinator() -> MainMenuFeatureCoordinator {
        return MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
}
```

### Test Pattern Usage
```swift
@Test("TeamFeatureCoordinator integrates with InteractorFactory correctly")
@MainActor
func testInteractorFactoryIntegration() async {
    // Arrange - Use factory pattern for consistent test setup
    let container = MockDependencyContainer()
    let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
    
    // Act
    coordinator.start()
    
    // Wait for async operations
    try? await Task.sleep(for: .milliseconds(10))
    
    // Assert - Verify factory integration
    #expect(coordinator.testHooks.interactor != nil)
    #expect(coordinator.testHooks.interactor is MockTeamInteractor)
}
```

### MockInteractorFactory Pattern
```swift
class MockInteractorFactory: InteractorFactoryProtocol {
    let mockNewGameInteractor = MockNewGameInteractor()
    let mockMainMenuInteractor = MockMainMenuInteractor()
    let mockTeamSelectInteractor = MockTeamSelectInteractor()
    
    func makeNewGameInteractor() -> NewGameInteractorProtocol {
        return mockNewGameInteractor
    }
    
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol {
        return MockTeamInteractor()
    }
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

## Interactor Protocol Pattern
Consistent delegate property across all interactor protocols:
```swift
protocol TeamInteractorProtocol: AnyObject {
    var viewModel: TeamViewModel { get }
    var eventBus: TeamEventBus { get }
    var delegate: TeamInteractorDelegate? { get set } // Consistent pattern
}

protocol NewGameInteractorProtocol: AnyObject {
    var viewModel: NewGameViewModel { get }
    var eventBus: NewGameEventBus { get }
    var delegate: NewGameInteractorDelegate? { get set } // Consistent pattern
}
```

## Key Benefits of InteractorFactory Pattern

### Type Safety
- Compile-time verification of dependencies
- Factory methods ensure correct interactor creation
- Protocol-based contracts prevent runtime errors

### Testability
- MockInteractorFactory provides consistent test doubles
- Easy to swap implementations for testing
- Clear separation between production and test dependencies

### Scalability
- Easy to add new interactors by extending factory protocol
- Parameterized factory methods support context-specific creation
- Consistent patterns across all features

### Maintainability
- Centralized interactor creation logic
- Clear dependency relationships
- Simplified coordinator construction and testing

This pattern system ensures maintainable, testable, and scalable architecture for the SuperSoccer application.

## Core Architectural Patterns (Applied to ALL Features)

### 1. InteractorFactory Pattern ✅ ESTABLISHED
**Purpose**: Type-safe dependency injection with unified testing interface

**Implementation**:
- `InteractorFactoryProtocol` defines factory methods for all feature interactors
- Production: `InteractorFactory` creates real interactors with real dependencies
- Testing: `MockDependencyContainer.interactorFactory` returns mock interactors

**Usage**:
```swift
// Production
let interactor = DependencyContainer.shared.interactorFactory.makeNewGameInteractor()

// Testing
let container = MockDependencyContainer()
let mockInteractor = container.interactorFactory.makeNewGameInteractor()
```

**Benefits**: Eliminates manual dependency wiring, enables easy testing, provides type safety

### 2. Protocol Separation Pattern ✅ ESTABLISHED
**Purpose**: Clean separation between coordinator and view communication

**Implementation**:
- Split interactor protocols into two distinct interfaces:
  - `[Feature]BusinessLogic`: For coordinator communication via delegate pattern
  - `[Feature]ViewPresenter`: For view communication via direct function calls
- Combined protocol: `[Feature]InteractorProtocol: BusinessLogic & ViewPresenter`

**Navigation Integration**:
- NavigationRouter uses `Screen.[feature](presenter: [Feature]ViewPresenter)`
- ViewFactory takes presenter parameter, not full interactor
- Coordinators use BusinessLogic interface, Views use Presenter interface

**Benefits**: Separation of concerns, clear dependencies, independent testability

### 3. ViewModelTransform Pattern ✅ NEW ESTABLISHED
**Purpose**: Dedicated transformation of data sources into presentation models

**Implementation**:
- `[Feature]ViewModelTransformProtocol` defines transformation interface
- Transform class handles all view model creation logic
- Interactor delegates view model creation to transform
- Mock available for isolated testing

**Example**:
```swift
protocol NewGameViewModelTransformProtocol {
    func transform(localData: NewGameLocalDataSource.Data) -> NewGameViewModel
}

final class NewGameViewModelTransform: NewGameViewModelTransformProtocol {
    func transform(localData: NewGameLocalDataSource.Data) -> NewGameViewModel {
        // Transform logic here
    }
}
```

**Benefits**: Single responsibility, testable transformation logic, reusable patterns

### 4. InteractorProtocol Pattern ✅ NEW ESTABLISHED
**Purpose**: Enhanced testability through protocol-based interactor design

**Implementation**:
- All interactors implement a dedicated protocol combining BusinessLogic + ViewPresenter
- Enables easy mocking and dependency injection
- Protocol provides complete interface contract

**Example**:
```swift
protocol NewGameInteractorProtocol: NewGameBusinessLogic & NewGameViewPresenter {}

final class NewGameInteractor: NewGameInteractorProtocol {
    init(dataManager: DataManagerProtocol,
         localDataSource: NewGameLocalDataSourceProtocol,
         newGameViewModelTransform: NewGameViewModelTransformProtocol) {
        // Constructor injection of all dependencies
    }
}
```

**Benefits**: Complete mockability, clear interface contracts, dependency injection support

### 5. Nested ViewModel Pattern ✅ NEW ESTABLISHED
**Purpose**: Hierarchical view model composition for complex views

**Implementation**:
- Parent view models contain child view models as properties
- Sub-views receive their specific view model from parent
- Transform classes create nested view model hierarchies

**Example**:
```swift
struct NewGameViewModel {
    var teamSelectorModel: TeamSelectorViewModel
    // other properties
}

struct NewGameView: View {
    let presenter: NewGameViewPresenter
    
    var body: some View {
        // Pass nested view model to sub-view
        TeamSelectorView(
            viewModel: presenter.viewModel.teamSelectorModel,
            action: { presenter.teamSelectorTapped() }
        )
    }
}
```

**Benefits**: Modular view composition, clear data flow, reusable sub-views

### 6. ViewModelTransform Pattern (NEW - Required for All Features)
```
Local Data Sources → ViewModelTransform → ViewModels → Views
```

**Purpose**: Dedicated transformation of raw data into presentation models, removing presentation logic from interactors.

**Structure:**
- **Transform Protocol**: `[Feature]ViewModelTransformProtocol` defines transformation interface
- **Transform Implementation**: `[Feature]ViewModelTransform` handles all view model creation logic
- **Mock Transform**: `Mock[Feature]ViewModelTransform` for isolated testing
- **Constructor Injection**: Transform injected into interactor via factory

**Example:**
```swift
protocol NewGameViewModelTransformProtocol {
    func transformToViewModel(
        localDataSource: NewGameLocalDataSourceProtocol
    ) -> NewGameViewModel
}

class NewGameViewModelTransform: NewGameViewModelTransformProtocol {
    func transformToViewModel(
        localDataSource: NewGameLocalDataSourceProtocol
    ) -> NewGameViewModel {
        let data = localDataSource.getCurrentData()
        
        return NewGameViewModel(
            coachName: data.coachName,
            coachCountry: data.coachCountry,
            teamSelectorModel: TeamSelectorViewModel(
                selectedTeamId: data.selectedTeamId,
                isTeamSelected: data.selectedTeamId != nil
            )
        )
    }
}

class NewGameInteractor: NewGameInteractorProtocol {
    private let viewModelTransform: NewGameViewModelTransformProtocol
    
    init(dataManager: DataManagerProtocol,
         localDataSource: NewGameLocalDataSourceProtocol,
         viewModelTransform: NewGameViewModelTransformProtocol) {
        self.viewModelTransform = viewModelTransform
        // ... other initialization
    }
    
    var viewModel: NewGameViewModel {
        return viewModelTransform.transformToViewModel(
            localDataSource: localDataSource
        )
    }
}
```

**Benefits:**
- **Single Responsibility**: Interactor focuses on business logic, transform handles presentation
- **Testability**: Transform logic can be tested in isolation
- **Reusability**: Transform patterns can be applied across features
- **Maintainability**: Clear separation between data and presentation concerns

### 7. InteractorProtocol Pattern (NEW - Required for All Features)
```
[Feature]BusinessLogic + [Feature]ViewPresenter = [Feature]InteractorProtocol
```

**Purpose**: Enhanced protocol design that combines all interactor interfaces for complete mockability.

**Structure:**
- **Business Logic Protocol**: Interface for coordinator communication
- **View Presenter Protocol**: Interface for view communication
- **Combined Protocol**: `[Feature]InteractorProtocol: [Feature]BusinessLogic & [Feature]ViewPresenter`
- **Mock Implementation**: Complete mockable interactor

**Example:**
```swift
protocol NewGameBusinessLogic: AnyObject {
    var delegate: NewGameBusinessLogicDelegate? { get set }
}

protocol NewGameViewPresenter: AnyObject {
    var viewModel: NewGameViewModel { get }
    func updateCoachName(_ name: String)
    func updateCoachCountry(_ country: String)
    func teamSelected(teamInfoId: String)
    func submitGameCreation()
}

protocol NewGameInteractorProtocol: NewGameBusinessLogic & NewGameViewPresenter {}

class NewGameInteractor: NewGameInteractorProtocol {
    // Implements both protocols with full functionality
}

class MockNewGameInteractor: NewGameInteractorProtocol {
    // Can mock both coordinator and view interactions
    var updateCoachNameCallCount = 0
    var submitGameCreationCallCount = 0
    var mockViewModel = NewGameViewModel()
    // ... complete mockability
}
```

**Benefits:**
- **Complete Mockability**: Every interactor can be fully mocked
- **Clear Contracts**: Protocol defines complete interface
- **Dependency Injection**: Constructor injection supports all dependencies
- **Type Safety**: Compile-time verification of implementations

### 8. Nested ViewModel Pattern (NEW - Required for Complex Views)
```
Parent ViewModel → Child ViewModels → Sub-Views
```

**Purpose**: Hierarchical view model composition for complex views with reusable sub-components.

**Structure:**
- **Parent ViewModel**: Contains child view models as properties
- **Child ViewModels**: Specific view models for sub-components
- **Hierarchical Composition**: Views receive appropriate view models
- **Reusable Components**: Sub-views can be used across features

**Example:**
```swift
struct NewGameViewModel {
    let coachName: String
    let coachCountry: String
    
    // Nested child view model
    let teamSelectorModel: TeamSelectorViewModel
    
    // Computed properties for validation
    var canSubmit: Bool {
        return !coachName.isEmpty && 
               !coachCountry.isEmpty && 
               teamSelectorModel.isTeamSelected
    }
}

struct TeamSelectorViewModel {
    let selectedTeamId: String?
    let isTeamSelected: Bool
    let teams: [TeamInfo]
    
    var selectedTeam: TeamInfo? {
        guard let selectedTeamId = selectedTeamId else { return nil }
        return teams.first { $0.id == selectedTeamId }
    }
}

// In the view:
struct NewGameView: View {
    let presenter: NewGameViewPresenter
    
    var body: some View {
        VStack {
            // Coach input fields
            TextField("Coach Name", text: .constant(presenter.viewModel.coachName))
            
            // Nested sub-view receives its specific view model
            TeamSelectorView(viewModel: presenter.viewModel.teamSelectorModel)
            
            // Submit button uses parent validation
            Button("Create Game") {
                presenter.submitGameCreation()
            }
            .disabled(!presenter.viewModel.canSubmit)
        }
    }
}
```

**Benefits:**
- **Modular Composition**: Complex views built from reusable components
- **Clear Data Flow**: Each sub-view gets exactly what it needs
- **Reusable Components**: Sub-views can be used across features
- **Hierarchical Organization**: Natural organization of presentation data

## Enhanced Testing Patterns (NEW STANDARD)

### Real vs Mock Testing Strategy
```swift
// Behavior Testing (Real interactor + Mock dependencies)
@Test func testBusinessLogicBehavior() async throws {
    let mocks = createMocks()
    let interactor = NewGameInteractor(
        dataManager: mocks.dataManager,
        localDataSource: mocks.localDataSource,
        viewModelTransform: mocks.viewModelTransform
    )
    
    // Test actual business logic behavior
    interactor.updateCoachName("Test Coach")
    
    // Verify effects in dependencies
    #expect(mocks.localDataSource.updateCoachNameCallCount == 1)
}

// Integration Testing (Mock interactor)
@Test func testViewIntegration() async throws {
    let mockInteractor = MockNewGameInteractor()
    let view = NewGameView(presenter: mockInteractor)
    
    // Test view-interactor integration
    mockInteractor.simulateDataChange()
    #expect(mockInteractor.viewModel.canSubmit == true)
}

// ViewModelTransform Testing (Isolated transformation logic)
@Test func testViewModelTransformation() async throws {
    let transform = NewGameViewModelTransform()
    let mockDataSource = MockNewGameLocalDataSource()
    
    mockDataSource.mockData = NewGameLocalData(
        coachName: "Test Coach",
        selectedTeamId: "team1"
    )
    
    let viewModel = transform.transformToViewModel(
        localDataSource: mockDataSource
    )
    
    #expect(viewModel.coachName == "Test Coach")
    #expect(viewModel.teamSelectorModel.isTeamSelected == true)
}
```

### Async Testing with Continuations
```swift
@Test func testAsyncBusinessLogic() async throws {
    let interactor = NewGameInteractor(/* dependencies */)
    
    await withCheckedContinuation { continuation in
        interactor.delegate = MockDelegate { result in
            // Verify result
            continuation.resume()
        }
        
        interactor.submitGameCreation()
    }
}
```

## Implementation Checklist for New Features

When creating a new feature with complete architecture:

### Core Implementation ✅
- [ ] **Protocol Separation**: Create BusinessLogic + ViewPresenter protocols
- [ ] **Combined Protocol**: Create InteractorProtocol combining both
- [ ] **EventBus Elimination**: Use direct function calls
- [ ] **InteractorFactory Integration**: Add factory method
- [ ] **ViewModelTransform**: Create transform protocol + implementation
- [ ] **Nested ViewModels**: Implement hierarchical composition if needed

### Navigation Integration ✅
- [ ] **NavigationRouter**: Add screen with presenter parameter
- [ ] **ViewFactory**: Create view with presenter parameter
- [ ] **Coordinator**: Use business logic for coordination

### Testing Excellence ✅
- [ ] **ViewModelTransform Tests**: Dedicated transformation testing
- [ ] **Real Interactor Tests**: Business logic with mock dependencies
- [ ] **Mock Interactor**: Complete mockable implementation
- [ ] **Async Testing**: Continuation-based patterns
- [ ] **Integration Tests**: View-presenter interaction

### Pattern Compliance ✅
- [ ] **Matches NewGame**: All patterns implemented consistently
- [ ] **Factory Created**: Interactor created via factory
- [ ] **Protocol Adherence**: Implements all required protocols
- [ ] **Testing Coverage**: Comprehensive test suite

## Feature Implementation Checklist

For each new feature, ensure ALL patterns are implemented:

### ✅ Core Architecture
- [ ] Protocol Separation (BusinessLogic + ViewPresenter + Combined)
- [ ] InteractorFactory integration  
- [ ] ViewModelTransform with protocol
- [ ] InteractorProtocol implementation
- [ ] Nested ViewModels where appropriate

### ✅ Navigation Integration
- [ ] NavigationRouter uses presenter parameter
- [ ] ViewFactory accepts presenter parameter
- [ ] Coordinator delegates business logic

### ✅ Testing Excellence
- [ ] MockDependencyContainer integration
- [ ] Real interactor + mock dependencies for behavior tests
- [ ] Mock interactor for integration tests
- [ ] ViewModelTransform dedicated tests
- [ ] Async patterns with continuation-based testing

## Testing Patterns

### Real Interactor Testing (Behavior Verification)
```swift
private func createMocks() -> (MockDataManager, MockLocalDataSource, MockViewModelTransform) {
    return (MockDataManager(), MockLocalDataSource(), MockViewModelTransform())
}

let interactor = FeatureInteractor(
    dataManager: mockDataManager,
    localDataSource: mockLocalDataSource,
    viewModelTransform: mockTransform
)
```

### Mock Interactor Testing (Integration Verification)
```swift
let container = MockDependencyContainer()
let mockInteractor = container.interactorFactory.makeFeatureInteractor()
#expect(mockInteractor is MockFeatureInteractor)
```

## Architecture Benefits

- **Consistency**: Every feature follows identical patterns
- **Testability**: Complete mockability at every layer
- **Maintainability**: Clear separation of concerns
- **Scalability**: Patterns support feature complexity growth
- **Type Safety**: Compile-time verification of dependencies
