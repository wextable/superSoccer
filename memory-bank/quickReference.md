# Quick Reference

## Key Commands & Patterns

### Creating a New Feature with InteractorFactory
Follow this exact structure and pattern:

#### 1. Create Feature Directory
```
Features/[FeatureName]/
├── [FeatureName]FeatureCoordinator.swift (uses InteractorFactory)
├── [FeatureName]Interactor.swift (created by factory)
├── [FeatureName]View.swift
├── [FeatureName]LocalDataSource.swift (if needed)
└── Supporting files (ViewModels, etc.)
```

#### 2. Feature Coordinator Template with InteractorFactory
```swift
enum [FeatureName]CoordinatorResult: CoordinatorResult {
    case completed(SomeData)
    case cancelled
}

class [FeatureName]FeatureCoordinator: BaseFeatureCoordinator<[FeatureName]CoordinatorResult> {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let interactorFactory: InteractorFactoryProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.interactorFactory = interactorFactory
        super.init()
    }
    
    override func start() {
        let interactor = interactorFactory.make[FeatureName]Interactor()
        interactor.delegate = self
        
        let screen = NavigationRouter.Screen.[featureName](interactor: interactor)
        Task { @MainActor in
            self.navigationCoordinator.presentSheet(screen)
        }
    }
}

extension [FeatureName]FeatureCoordinator: [FeatureName]InteractorDelegate {
    func [featureName]Completed(with data: SomeData) {
        finish(with: .completed(data))
    }
}

#if DEBUG
extension [FeatureName]FeatureCoordinator {
    struct TestHooks {
        let interactor: [FeatureName]InteractorProtocol
        let navigationCoordinator: NavigationCoordinatorProtocol
    }
    
    var testHooks: TestHooks {
        TestHooks(
            interactor: interactor,
            navigationCoordinator: navigationCoordinator
        )
    }
}
#endif
```

#### 3. Parameterized Coordinator Template (for context-specific features)
```swift
class [FeatureName]FeatureCoordinator: BaseFeatureCoordinator<[FeatureName]CoordinatorResult> {
    private let contextId: String // Example parameter
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let interactorFactory: InteractorFactoryProtocol
    
    init(contextId: String,
         navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.contextId = contextId
        self.navigationCoordinator = navigationCoordinator
        self.interactorFactory = interactorFactory
        super.init()
    }
    
    override func start() {
        let interactor = interactorFactory.make[FeatureName]Interactor(contextId: contextId)
        interactor.delegate = self
        
        let screen = NavigationRouter.Screen.[featureName](interactor: interactor)
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(screen)
        }
    }
}
```

#### 4. InteractorFactory Extension
Add your new interactor to the factory protocol and implementations:

```swift
// In InteractorFactoryProtocol
func make[FeatureName]Interactor() -> [FeatureName]InteractorProtocol
// For parameterized: func make[FeatureName]Interactor(contextId: String) -> [FeatureName]InteractorProtocol

// In InteractorFactory
func make[FeatureName]Interactor() -> [FeatureName]InteractorProtocol {
    return [FeatureName]Interactor(dataManager: dataManager)
}

// In MockInteractorFactory
let mock[FeatureName]Interactor = Mock[FeatureName]Interactor()

func make[FeatureName]Interactor() -> [FeatureName]InteractorProtocol {
    return mock[FeatureName]Interactor
}
```

#### 5. Interactor Template with Consistent Delegate Pattern
```swift
typealias [FeatureName]EventBus = PassthroughSubject<[FeatureName]Event, Never>

enum [FeatureName]Event: BusEvent {
    case loadData
    case actionPerformed(String)
}

protocol [FeatureName]InteractorDelegate: AnyObject {
    func [featureName]Completed(with data: SomeData)
}

protocol [FeatureName]InteractorProtocol: AnyObject {
    var viewModel: [FeatureName]ViewModel { get }
    var eventBus: [FeatureName]EventBus { get }
    var delegate: [FeatureName]InteractorDelegate? { get set } // Consistent pattern
}

class [FeatureName]Interactor: [FeatureName]InteractorProtocol {
    @Published var viewModel: [FeatureName]ViewModel
    let eventBus = [FeatureName]EventBus()
    weak var delegate: [FeatureName]InteractorDelegate? // Consistent pattern
    
    private let dataManager: DataManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Factory-compatible initialization (no delegate in constructor)
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        self.viewModel = [FeatureName]ViewModel(/* initial state */)
        
        setupSubscriptions()
        loadData()
    }
    
    // Parameterized factory initialization example
    init(contextId: String, dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        self.viewModel = [FeatureName]ViewModel(/* initial state with contextId */)
        
        setupSubscriptions()
        loadData()
    }
    
    private func setupSubscriptions() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .loadData:
                    self?.loadData()
                case .actionPerformed(let data):
                    self?.handleAction(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        // Load and process data
        // Update viewModel
    }
    
    private func handleAction(_ data: String) {
        delegate?.[featureName]Completed(with: data)
    }
}

#if DEBUG
class Mock[FeatureName]Interactor: [FeatureName]InteractorProtocol {
    @Published var viewModel: [FeatureName]ViewModel
    let eventBus = [FeatureName]EventBus()
    weak var delegate: [FeatureName]InteractorDelegate? // Consistent pattern
    
    init() {
        self.viewModel = .make()
    }
}

class Mock[FeatureName]InteractorDelegate: [FeatureName]InteractorDelegate {
    var completedCalled = false
    var lastCompletedData: SomeData?
    var onCompleted: (() -> Void)?
    
    func [featureName]Completed(with data: SomeData) {
        completedCalled = true
        lastCompletedData = data
        onCompleted?()
    }
}
#endif
```

#### 6. View Template (unchanged - uses factory-created interactor)
```swift
struct [FeatureName]ViewModel {
    let title: String
    let items: [ItemViewModel]
}

struct [FeatureName]View: View {
    let interactor: any [FeatureName]InteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.medium) {
            SSTitle(interactor.viewModel.title)
            
            // Feature content here
            
            SSPrimaryButton("Action") {
                interactor.eventBus.send(.actionPerformed("data"))
            }
        }
        .padding(theme.spacing.large)
        .background(theme.colors.background)
        .navigationTitle(interactor.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#if DEBUG
extension [FeatureName]ViewModel {
    static func make(
        title: String = "Default Title",
        items: [ItemViewModel] = [.make()]
    ) -> Self {
        self.init(title: title, items: items)
    }
}
#endif
```

#### 7. MockDependencyContainer Extension
Add coordinator factory method to MockDependencyContainer:

```swift
// In MockDependencyContainer
func make[FeatureName]Coordinator() -> [FeatureName]FeatureCoordinator {
    return [FeatureName]FeatureCoordinator(
        navigationCoordinator: mockNavigationCoordinator,
        interactorFactory: mockInteractorFactory
    )
}

// For parameterized coordinators
func make[FeatureName]Coordinator(contextId: String) -> [FeatureName]FeatureCoordinator {
    return [FeatureName]FeatureCoordinator(
        contextId: contextId,
        navigationCoordinator: mockNavigationCoordinator,
        interactorFactory: mockInteractorFactory
    )
}
```

### Adding Unit Tests with InteractorFactory (Following Team Template)

#### Test File Template with MockDependencyContainer
```swift
import Combine
import Foundation
@testable import SuperSoccer
import Testing

struct [FeatureName]InteractorTests {
    
    // MARK: - Initialization Tests
    
    @Test("[FeatureName]Interactor initializes with correct dependencies")
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let interactor = container.mockInteractorFactory.make[FeatureName]Interactor()
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.viewModel != nil)
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Event Bus Tests
    
    @Test("[FeatureName]Interactor handles loadData event correctly")
    func testHandleLoadDataEvent() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.mockInteractorFactory.make[FeatureName]Interactor()
        
        // Act
        interactor.eventBus.send(.loadData)
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(interactor.viewModel.items.isEmpty == false)
    }
    
    // MARK: - Delegate Tests
    
    @Test("[FeatureName]Interactor forwards delegate calls correctly")
    func testDelegateForwarding() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.mockInteractorFactory.make[FeatureName]Interactor()
        let mockDelegate = Mock[FeatureName]InteractorDelegate()
        
        var delegateCallReceived = false
        await confirmation { confirmation in
            mockDelegate.onCompleted = {
                delegateCallReceived = true
                confirmation()
            }
            
            // Act
            interactor.delegate = mockDelegate
            interactor.eventBus.send(.actionPerformed("test"))
        }
        
        // Assert
        #expect(delegateCallReceived == true)
        #expect(mockDelegate.completedCalled == true)
    }
}

struct [FeatureName]FeatureCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("[FeatureName]FeatureCoordinator initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.make[FeatureName]Coordinator()
        
        // Assert
        #expect(coordinator != nil)
    }
    
    @Test("[FeatureName]FeatureCoordinator sets up interactor delegate correctly")
    @MainActor
    func testInteractorDelegateSetup() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.make[FeatureName]Coordinator()
        
        // Act
        coordinator.start()
        
        // Assert
        let interactor = coordinator.testHooks.interactor
        #expect(interactor.delegate === coordinator)
    }
    
    // MARK: - InteractorFactory Integration Tests
    
    @Test("[FeatureName]FeatureCoordinator integrates with InteractorFactory correctly")
    @MainActor
    func testInteractorFactoryIntegration() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.make[FeatureName]Coordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert - Verify interactor was created via factory
        #expect(coordinator.testHooks.interactor != nil)
        #expect(coordinator.testHooks.interactor is Mock[FeatureName]Interactor)
    }
}
```

### Testing Patterns with InteractorFactory

#### Basic Test Setup Pattern
```swift
// Use MockDependencyContainer for all test setup
let container = MockDependencyContainer()
let coordinator = container.make[FeatureName]Coordinator()
```

#### Parameterized Test Setup Pattern
```swift
// For coordinators requiring parameters
let container = MockDependencyContainer()
let coordinator = container.make[FeatureName]Coordinator(contextId: "test-id")
```

#### Factory Integration Verification
```swift
// Verify factory-created interactors
#expect(coordinator.testHooks.interactor is Mock[FeatureName]Interactor)
#expect(coordinator.testHooks.interactor === container.mockInteractorFactory.mock[FeatureName]Interactor)
```

### Data Operations Templates

#### Request/Result Pattern
```swift
struct [Operation]Request {
    let inputData: String
    let additionalParams: [String: Any]
}

struct [Operation]Result {
    let outputData: [SomeModel]
    let success: Bool
    let errorMessage: String?
}

// In DataManagerProtocol
func [operation](_ request: [Operation]Request) async throws -> [Operation]Result

// In DataManager implementation  
func [operation](_ request: [Operation]Request) async throws -> [Operation]Result {
    // Use transformers and storage
    let swiftDataModels = try await storage.[operation](request)
    let clientModels = swiftDataToClientTransformer.transform[Models](swiftDataModels)
    return [Operation]Result(outputData: clientModels, success: true)
}
```

### Design System Usage Templates

#### SSTheme Integration
```swift
struct SomeView: View {
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.medium) {
            SSTitle("Title Text")
                .foregroundStyle(theme.colors.primaryText)
            
            SSPrimaryButton("Action") {
                // Action
            }
        }
        .padding(theme.spacing.large)
        .background(theme.colors.background)
    }
}
```

#### Button Usage
```swift
// Primary action button
SSPrimaryButton("Continue") {
    // Action
}

// Secondary button
SSSecondaryButton("Cancel") {
    // Action  
}

// Text button
SSTextButton("Skip") {
    // Action
}
```

#### Text Components
```swift
// Titles for headers
SSTitle("Screen Title")

// Labels for content
SSLabel("Description text")
    .style(.body) // .caption, .body, .headline

// Text fields
TextField("Placeholder", text: $text)
    .textFieldStyle(SSTextFieldStyle())
```

### Common Code Snippets

#### EventBus Communication Pattern
```swift
// In View
Button("Action") {
    interactor.eventBus.send(.someEvent(data))
}

// In Interactor
eventBus
    .sink { [weak self] event in
        switch event {
        case .someEvent(let data):
            self?.handleEvent(data)
        }
    }
    .store(in: &cancellables)
```

#### Reactive UI Updates
```swift
// In Interactor - publish changes
self.viewModel = UpdatedViewModel(newData)

// In View - automatic updates
@StateObject private var viewModel = interactor.viewModel

var body: some View {
    // UI updates automatically when viewModel changes
    Text(viewModel.title)
}
```

#### Navigation Router Screen Addition
```swift
// In NavigationRouter.Screen enum
case [featureName](interactor: any [FeatureName]InteractorProtocol)

// In NavigationRouter screen creation
case .[featureName](let interactor):
    AnyView([FeatureName]View(interactor: interactor))
```

### Build & Test Commands

#### Build Project
```bash
xcodebuild build -scheme SuperSoccer -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.3.1'
```

#### Run All Tests
```bash
xcodebuild test -scheme SuperSoccer -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.3.1'
```

#### Run Specific Test Class
```bash
xcodebuild test -scheme SuperSoccer -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.3.1' -only-testing:SuperSoccerTests/[FeatureName]InteractorTests
```

#### Run Feature Tests Only
```bash
xcodebuild test -scheme SuperSoccer -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.3.1' -only-testing:SuperSoccerTests/Features
```

### Key Architecture Rules with InteractorFactory

1. **Always use InteractorFactory for interactor creation** - Never instantiate interactors directly
2. **Consistent delegate pattern** - All InteractorProtocols must have `var delegate: [Feature]InteractorDelegate? { get set }`
3. **Factory parameter support** - Use parameterized factory methods for context-specific interactors
4. **Test with MockDependencyContainer** - Use unified testing pattern: `container.make[Feature]Coordinator()`
5. **Protocol-based design** - Every factory method returns a protocol, not concrete type
6. **TestHooks for verification** - Use testHooks to verify internal state in tests
7. **No delegate in constructors** - Factory-created interactors set delegate after creation

This quick reference provides copy-paste ready templates following the established InteractorFactory architecture patterns used throughout SuperSoccer. 